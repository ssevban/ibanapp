class IbanModel {
  final String iban;
  final String name;
  final String bankName;

  IbanModel({
    required this.iban,
    required this.name,
    required this.bankName,
  });

  Map<String, dynamic> toJson() {
    return {
      'iban': iban,
      'name': name,
      'bankName': bankName,
    };
  }

  factory IbanModel.fromJson(Map<String, dynamic> json) {
    return IbanModel(
      iban: json['iban'],
      name: json['name'],
      bankName: json['bankName'],
    );
  }
}
