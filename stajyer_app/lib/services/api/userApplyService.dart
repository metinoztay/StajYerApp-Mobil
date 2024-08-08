import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/models/homeAdvModel.dart';
import 'package:stajyer_app/services/endpoints.dart';

class Userapplyservice {
  final String baseUrl = endpoints.baseUrl;

  Future<List<HomeAdvModel>> fetchApplyAdvertsByUserId(int userId) async {
    final url = Uri.parse('$baseUrl/Application/ListUsersAllApplications/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      if (jsonResponse is Map && jsonResponse.containsKey('\$values')) {
        final List<dynamic> dataList = jsonResponse['\$values'];
        return dataList.map((item) => HomeAdvModel.fromJson(item)).toList();
      } else {
        print('API yanıtı beklenmedik bir formatta: $jsonResponse');
        throw Exception('Beklenmedik yanıt formatı');
      }
    } else {
      throw Exception('Kayıtlı ilanlar yüklenemedi: ${response.statusCode}');
    }
  }
}
