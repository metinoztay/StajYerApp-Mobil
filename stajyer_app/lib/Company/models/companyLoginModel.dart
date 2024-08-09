class CompanyLoginModel {
  final int compUserId;
  final String nameSurname;
  final String phone;
  final String email;
  final String password;
  final String taxNumber;
  final int taxCityId;
  final int taxOfficeId;
  final bool isVerified;
  final bool hasSetPassword;

  CompanyLoginModel({
    required this.compUserId,
    required this.nameSurname,
    required this.phone,
    required this.email,
    required this.password,
    required this.taxNumber,
    required this.taxCityId, 
    required this.taxOfficeId,
    required this.isVerified,
    required this.hasSetPassword,
  });

  factory CompanyLoginModel.fromJson(Map<String, dynamic> json) {
    return CompanyLoginModel(
      compUserId: json['compUserId'],
      nameSurname: json['nameSurname'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      taxNumber: json['taxNumber'],
      taxCityId: json['taxCityId'],
      taxOfficeId: json['taxOfficeId'],
      isVerified: json['isVerified'],
      hasSetPassword: json['hasSetPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compUserId': compUserId,
      'nameSurname': nameSurname,
      'phone': phone,
      'email': email,
      'password': password,
      'taxNumber': taxNumber,
      'taxCityId': taxCityId,
      'taxOfficeId': taxOfficeId,
      'isVerified': isVerified,
      'hasSetPassword': hasSetPassword,
    };
  }
}
