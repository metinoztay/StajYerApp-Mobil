import 'dart:convert';

import 'package:stajyer_app/User/models/CompanyModel.dart';
import 'package:stajyer_app/User/services/endpoints.dart';
import 'package:http/http.dart' as http;

//TÜM ŞİRKETLERİ LİSTELEME
class CompanyService {
  Future<List<CompanyModel>> getCompanies() async {
    final response =
        await http.get(Uri.parse(endpoints.CompanyListUrl)); // Endpoint

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      // $values anahtarı altındaki listeyi alıyoruz
      List<dynamic> companiesJson = body['\$values'];

      List<CompanyModel> companies = companiesJson
          .map((dynamic item) => CompanyModel.fromJson(item))
          .toList();
      return companies;
    } else {
      throw Exception('Failed to load companies');
    }
  }

  ///IDYE GÖRE COMPANY
  Future<CompanyModel> getCompanyById(int compId) async {
    try {
      final response = await http.get(
        Uri.parse(endpoints.GetCompanyByIdUrl + '/$compId'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return CompanyModel.fromJson(data);
      } else {
        print('Failed to fetch company. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch company');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to fetch company: $e');
    }
  }
}
