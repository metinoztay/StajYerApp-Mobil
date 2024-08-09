import 'package:stajyer_app/User/models/homeAdvModel.dart';

class CompanyUser {
  final int compUserId;
  final String? nameSurname;
  final String? phone;
  final String? email;
  final String? password;
  final String? taxNumber;
  final int taxCityId;
  final int taxOfficeId;
  final bool isVerified;
  final bool hasSetPassword;
  final List<Company>? companies;

  CompanyUser({
    required this.compUserId,
    this.nameSurname,
    this.phone,
    this.email,
    this.password,
    this.taxNumber,
    required this.taxCityId,
    required this.taxOfficeId,
    required this.isVerified,
    required this.hasSetPassword,
    this.companies,
  });
  factory CompanyUser.fromJson(Map<String, dynamic> json) {
    return CompanyUser(
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
      companies: (json['companies'] as List<dynamic>?)
          ?.map((comp) => Company.fromJson(comp))
          .toList(),
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
      'companies': companies?.map((comp) => comp.toJson()).toList(),
    };
  }
}
