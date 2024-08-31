import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/User/services/endpoints.dart';

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
  // API'nizin temel URL'sini buraya ekleyin

  Future<String> getUniversityName(int uniId) async {
    final response = await http.get(Uri.parse(
        'http://stajyerapp.runasp.net/api/Univercity/ListUnivercities${uniId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['uniName']; // API yanıtına göre anahtar ismi
    } else {
      throw Exception('Üniversite adı yüklenemedi');
    }
  }

  Future<Map<String, dynamic>> getProgramById(int progId) async {
    final url = Uri.parse(
        'http://stajyerapp.runasp.net/api/Univercity/ListPrograms${progId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Program bilgileri yüklenemedi');
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
