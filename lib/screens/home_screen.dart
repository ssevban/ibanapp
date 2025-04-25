import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/iban_model.dart';
import '../providers/iban_provider.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('IBAN Kayıt'),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: Consumer<IbanProvider>(
        builder: (context, ibanProvider, child) {
          return ReorderableListView.builder(
            itemCount: ibanProvider.ibans.length,
            onReorder: (oldIndex, newIndex) {
              ibanProvider.reorderIbans(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final iban = ibanProvider.ibans[index];
              final bankName = ibanProvider.getBankName(iban.iban);

              return Dismissible(
                key: ValueKey(iban.iban),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('IBAN Sil'),
                      content: Text(
                          '${iban.name} isimli IBAN\'ı silmek istediğinize emin misiniz?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('İptal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Sil'),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  ibanProvider.deleteIban(iban.iban);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${iban.name} isimli IBAN silindi'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: isDarkMode ? 4 : 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: isDarkMode
                          ? Border.all(color: Colors.blue.withOpacity(0.3))
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            iban.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : null,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  iban.iban,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDarkMode
                                        ? Colors.white.withOpacity(0.9)
                                        : null,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.copy,
                                  color: isDarkMode
                                      ? Colors.blue.withOpacity(0.8)
                                      : null,
                                ),
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: iban.iban));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('IBAN kopyalandı'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bankName,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Colors.blue.withOpacity(0.7)
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddIbanDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddIbanDialog(BuildContext context) {
    final ibanController = TextEditingController();
    final nameController = TextEditingController();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni IBAN Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'İsim',
                hintText: 'IBAN sahibinin adı',
              ),
              onChanged: (value) {
                nameController.text = value.replaceAll(' ', '');
                nameController.selection = TextSelection.fromPosition(
                  TextPosition(offset: nameController.text.length),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ibanController,
              decoration: const InputDecoration(
                labelText: 'IBAN',
                hintText: 'TR...',
              ),
              onChanged: (value) {
                ibanController.text = value.replaceAll(' ', '');
                ibanController.selection = TextSelection.fromPosition(
                  TextPosition(offset: ibanController.text.length),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              if (ibanController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                final ibanProvider =
                    Provider.of<IbanProvider>(context, listen: false);
                final bankName = ibanProvider.getBankName(ibanController.text);
                final newIban = IbanModel(
                  iban: ibanController.text.replaceAll(' ', ''),
                  name: nameController.text.replaceAll(' ', ''),
                  bankName: bankName,
                );
                ibanProvider.addIban(newIban);
                Navigator.pop(context);
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
