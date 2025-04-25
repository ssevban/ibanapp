import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/iban_model.dart';

class IbanProvider with ChangeNotifier {
  List<IbanModel> _ibans = [];
  final String _storageKey = 'ibans';

  List<IbanModel> get ibans => _ibans;

  IbanProvider() {
    _loadIbans();
  }

  Future<void> _loadIbans() async {
    final prefs = await SharedPreferences.getInstance();
    final ibansJson = prefs.getStringList(_storageKey) ?? [];
    _ibans =
        ibansJson.map((json) => IbanModel.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

  Future<void> addIban(IbanModel iban) async {
    _ibans.add(iban);
    await saveIbans();
    notifyListeners();
  }

  Future<void> deleteIban(String iban) async {
    _ibans.removeWhere((item) => item.iban == iban);
    await saveIbans();
    notifyListeners();
  }

  Future<void> reorderIbans(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final iban = _ibans.removeAt(oldIndex);
    _ibans.insert(newIndex, iban);
    await saveIbans();
    notifyListeners();
  }

  Future<void> saveIbans() async {
    final prefs = await SharedPreferences.getInstance();
    final ibansJson = _ibans.map((iban) => jsonEncode(iban.toJson())).toList();
    await prefs.setStringList(_storageKey, ibansJson);
  }

  String getBankName(String iban) {
    if (iban.length < 10) return 'Bilinmeyen Banka';

    // IBAN'ın banka kodunu al (5 karakter)
    final bankCode = iban.substring(4, 9);

    switch (bankCode) {
      case '00001':
        return 'TC Merkez Bankası';
      case '00004':
        return 'İller Bankası';
      case '00010':
        return 'Ziraat Bankası';
      case '00012':
        return 'Halkbank';
      case '00015':
        return 'Vakıfbank';
      case '00017':
        return 'Kalkınma Bankası';
      case '00029':
        return 'Birleşik Fon Bankası';
      case '00032':
        return 'Türk Ekonomi Bankası (TEB)';
      case '00046':
        return 'Akbank';
      case '00059':
        return 'Şekerbank';
      case '00062':
        return 'Garanti Bankası';
      case '00064':
        return 'İş Bankası';
      case '00067':
        return 'Yapı ve Kredi Bankası';
      case '00071':
        return 'Fortis Bank';
      case '00091':
        return 'Anadolubank';
      case '00092':
        return 'Citibank';
      case '00096':
        return 'Turkish Bank';
      case '00098':
        return 'Bank Mellat';
      case '00099':
        return 'ING Bank';
      case '00100':
        return 'Adabank';
      case '00111':
        return 'QNB Finansbank';
      case '00123':
        return 'HSBC';
      case '00124':
        return 'Alternatifbank';
      case '00125':
        return 'Burgan Bank';
      case '00129':
        return 'Merrill Lynch';
      case '00134':
        return 'Denizbank';
      case '00135':
        return 'Arap Türk Bankası';
      case '00137':
        return 'Société Générale';
      case '00138':
        return 'Deutsche Bank';
      case '00139':
        return 'Portigon AG';
      case '00141':
        return 'Nurol Yatırım Bankası';
      case '00142':
        return 'Bankpozitif Kredi ve Kalkınma Bankası';
      case '00143':
        return 'Aktif Yatırım Bankası';
      case '00146':
        return 'Odea Bank';
      case '00147':
        return 'Bank of Tokyo-Mitsubishi UFJ Turkey';
      case '00148':
        return 'Intesa Sanpaolo';
      case '00149':
        return 'Rabobank';
      case '00150':
        return 'Fibabanka';
      case '00151':
        return 'ICBC Turkey Bank';
      case '00153':
        return 'Bank of China Turkey';
      case '00205':
        return 'Kuveyt Türk Katılım Bankası';
      case '00206':
        return 'Türkiye Finans Katılım Bankası';
      case '00209':
        return 'Ziraat Katılım Bankası';
      case '00210':
        return 'Vakıf Katılım Bankası';
      case '00203':
        return 'Albaraka Türk Katılım Bankası';
      case '00211':
        return 'Emlak Katılım Bankası';
      default:
        return 'Bilinmeyen Banka';
    }
  }
}
