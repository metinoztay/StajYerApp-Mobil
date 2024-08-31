import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/User/services/endpoints.dart';

class CityService {
  Future<List<Map<String, dynamic>>> getCitys() async {
    final response =
        await http.get(Uri.parse('${endpoints.baseUrl}/City/ListCities'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Yanıtı: $data'); // Yanıtı loglayın
      final citysData = data['\$values'];
      if (citysData == null) {
        print('Veri boş döndü');
        return [];
      }
      return List<Map<String, dynamic>>.from(citysData);
    } else {
      throw Exception('Şehirler alınamadı: ${response.statusCode}');
    }
  }

  Future<String> getCityById(int cityId) async {
    final response = await http.get(
        Uri.parse('http://stajyerapp.runasp.net/api/City/ListCities${cityId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cityName'];
    } else {
      throw Exception('Şehirler adı alınamadı: ${response.statusCode}');
    }
  }
}
