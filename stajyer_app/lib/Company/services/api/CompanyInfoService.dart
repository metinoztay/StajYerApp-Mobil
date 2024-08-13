import 'package:stajyer_app/Company/models/Company.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/Company/services/Endpoints.dart';

class CompanyInfoService {
  //COMPANYUSER IDYE GÖRE BİLGİLERİ
  Future<Company> getCompanyInfoByCompUserId(int companyUserId) async {
    try {
      final response = await http.get(
        Uri.parse(Endpoints.GetCompanyByCompanyUserId + '/$companyUserId'),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        Company company = Company.fromJson(data);
        return company;
      } else {
        print('Failed to fetch company. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch company.');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to fetch company: $e');
    }
  }
}
