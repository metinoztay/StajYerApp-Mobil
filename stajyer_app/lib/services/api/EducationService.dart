import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/models/EducationModel.dart';
import 'package:stajyer_app/services/api/UnivercityService.dart';
import 'package:stajyer_app/services/endpoints.dart';

class EducationService {
  // BELİRLİ BİR KULLANICININ EĞİTİMLERİNİ GETİRME
  final UnivercityService _univercityService = UnivercityService();

  Future<List<EducationModel>> GetUserEducations(int userId) async {
    final String apiUrl = '${endpoints.GetEducationByUserIdUrl}/$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('API Yanıtı: ${response.body}');
        final Map<String, dynamic> data = json.decode(response.body);
        final jsonList = data['\$values'] as List<dynamic>;
        final educationList = jsonList
            .map((jsonItem) =>
                EducationModel.fromJson(jsonItem as Map<String, dynamic>))
            .toList();

        // Üniversite adlarını almak için listeyi çektik
        final universities = await _univercityService.getUniversities();
        final universityMap = {
          for (var uni in universities) uni['uniId']: uni['uniName']
        }; //üni id ve üniname eşleşti

        // eğitimler için üniversite adları eklendi
        for (var education in educationList) {
          education.uniName = universityMap[education.uniId];
        }

        return educationList;
      } else {
        print('API Hatası: ${response.statusCode} - ${response.body}');
        throw Exception('Eğitim bilgileri alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata: $e');
      throw Exception('Eğitim bilgileri alınırken bir hata oluştu: $e');
    }
  }

  // YENİ EĞİTİM EKLEME
  Future<bool> AddEducation(EducationModel education) async {
    try {
      final response = await http.post(Uri.parse(endpoints.addEducationUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(education.toJson()));

      if (response.statusCode == 200) {
        print('Eğitim eklendi');
        return true;
      } else {
        print('Eğitim eklenemedi status code = ${response.statusCode}');
        print('Hata mesajı: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Hata: $e');
      return false;
    }
  }

  Future<void> deleteEducation(int educationId) async {
    final url = Uri.parse(
        '${endpoints.baseUrl}/Education/DeleteEducation/$educationId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print("Eğitim bilgisi silindi");
    } else {
      print("Eğitim bilgisi silinirken hata oluştu: ${response.statusCode}");
      throw Exception("Eğitim bilgisi silinirken hata oluştu");
    }
  }
}