import 'package:stajyer_app/User/models/ExperienceModel.dart';
import 'package:stajyer_app/User/services/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExperienceService {
  //BİR KULLANICININ DENEYİMLERİNİ GETİRME

  Future<List<ExperienceModel>> GetUserExperiences(int userId) async {
    final String apiUrl = '${endpoints.GetExperienceByUserIdUrl}/$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print("apı yanıtı : ${response.body}");
        Map<String, dynamic> data = json.decode(response.body);

        return ExperienceModel.fromJsonList(data);
      } else {
        print('API HATASI: ${response.statusCode} - ${response.body}');
        throw Exception('SDeneyimler alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata : $e');
      throw Exception('deneyimler alınırken bir hata oluştu: $e');
    }
  }

  //YENİ DENEYİM EKLEME
  Future<bool> AddExperience(ExperienceModel experience) async {
    try {
      final response = await http.post(Uri.parse(endpoints.addExperienceUrl),
          headers: {
            'Content-Type':
                'application/json', // GÖNDERİLEN VERİ JSON FORMATINDA
          },
          body: jsonEncode(experience.toJson()));

      print('İstek gönderildi: ${endpoints.addCertificateUrl}');
      print('İstek başlıkları: ${response.headers}');
      print('İstek gövdesi: ${response.body}');

      if (response.statusCode == 200) {
        print("deneyim eklendi");
        return true;
      } else {
        print('deneyim eklenemedi ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Hata: ${e}');
      return false;
    }
  }
  //Deneyim Silme

  Future<void> deleteExperience(int experienceId) async {
    final response = await http
        .delete(Uri.parse('${endpoints.deleteExperienceUrl}/${experienceId}'));

    if (response.statusCode == 200) {
      print("deneyim silindi");
    } else {
      print("deneyim silinirken sorun oluştu : ${response.statusCode}");
      throw Exception("deneyim silinirken hata oluştu");
    }
  }
}