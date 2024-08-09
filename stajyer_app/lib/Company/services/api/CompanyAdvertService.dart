import 'package:stajyer_app/Company/models/Advertisement.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/Company/services/Endpoints.dart';

class CompanyAdvertService {
  Future<List<Advertisement>> fetchAdvertisementsByCompanyUserId(
      int companyUserId) async {
    final response = await http.get(
        Uri.parse('${Endpoints.ListAdvertByCompanyUserId}/$companyUserId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // JSON verisini Advertisement modeline dönüştür
      List<Advertisement> advertisements = (data['\$values'] as List)
          .map((ad) => Advertisement.fromJson(ad))
          .toList();
      return advertisements;
    } else {
      throw Exception('Failed to load advertisements');
    }
  }
}
