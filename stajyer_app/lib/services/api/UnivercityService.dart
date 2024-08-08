import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/services/endpoints.dart';

class UnivercityService {
  Future<List<Map<String, dynamic>>> getUniversities() async {
    final response = await http
        .get(Uri.parse('${endpoints.baseUrl}/Univercity/ListUnivercities'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Yanıtı: $data'); // Yanıtı loglayın
      final universitiesData =
          data['\$values']; // Burada $values anahtarını kullanıyoruz
      if (universitiesData == null) {
        print('Veri boş döndü.');
        return [];
      }
      return List<Map<String, dynamic>>.from(universitiesData);
    } else {
      throw Exception('Üniversiteler alınamadı: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> getPrograms() async {
    final response = await http
        .get(Uri.parse('${endpoints.baseUrl}/Univercity/ListPrograms'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Yanıtı: $data'); // Yanıtı loglayın
      final programsData =
          data['\$values']; // Burada $values anahtarını kullanıyoruz
      if (programsData == null) {
        print('Veri boş döndü.');
        return [];
      }
      return List<Map<String, dynamic>>.from(programsData);
    } else {
      throw Exception('Programlar alınamadı: ${response.statusCode}');
    }
  }
}