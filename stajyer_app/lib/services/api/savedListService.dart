import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/models/homeAdvModel.dart';
import 'package:stajyer_app/services/endpoints.dart';

class SavedlistService {
  final String baseUrl = endpoints.baseUrl;

  Future<List<HomeAdvModel>> fetchSavedAdvertsByUserId(int userId) async {
    final url = Uri.parse('$baseUrl/Advert/ListUsersSavedAdverts/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) { 
      final dynamic jsonResponse = json.decode(response.body);
      
      // Yanıtın özel formatını işleyin
      if (jsonResponse is Map && jsonResponse.containsKey('\$values')) {
        // 'values' anahtarını kullanarak listeye erişin
        final List<dynamic> dataList = jsonResponse['\$values'];
        return dataList.map((item) => HomeAdvModel.fromJson(item)).toList();
      } else {
        // Beklenmedik yanıt formatını yalnızca terminalde yazdırın
        print('API yanıtı beklenmedik bir formatta: $jsonResponse');
        return []; // Boş bir liste döndür
      }
    } else {
      // Hata kodunu yalnızca terminalde yazdırın
      print('Kayıtlı ilanlar yüklenemedi: ${response.statusCode}');
      return []; // Boş bir liste döndür
    }
  }
} 