import 'package:stajyer_app/Company/models/CompanyRegisterModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/Company/services/Endpoints.dart';

class CompanyRegisterService {
  Future<bool> CreateCompanyUser(CompanyRegisterModel newCompany) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.companyUserRegisterUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newCompany.toJson()),
      );

      if (response.statusCode == 200) {
        print("Şirket kullanıcı eklendi");
        return true;
      } else {
        print(
            'Şirket kullanıcı eklenemedi status code = ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('hata: $e');
      return false;
    }
  }
}
