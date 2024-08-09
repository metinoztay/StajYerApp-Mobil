import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/User/models/CertificateModel.dart';
import 'package:stajyer_app/User/services/endpoints.dart';

class CertificateService {
//BELİRLİ BİR KULLANICININ SERTİFİKALARINI GETİRME
  Future<List<CertificateModel>> GetUserCertificates(int userId) async {
    final String apiUrl = '${endpoints.GetCertifiaceByUserIdUrl}/$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl)); //istek

      if (response.statusCode == 200) {
        //yanıt

        print('API Yanıtı: ${response.body}');
        Map<String, dynamic> data = json.decode(response.body);

        return CertificateModel.fromJsonList(
            data); //JSON VERİLERİNİ LİSTEYE DÖNÜŞTÜR
      } else {
        print('API Hatası: ${response.statusCode} - ${response.body}');
        throw Exception('Sertifikalar alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata: $e');
      throw Exception('Sertifikalar alınırken bir hata oluştu: $e');
    }
  }

  //YENİ SERTİFİKA EKLEME
  Future<bool> AddCertificate(CertificateModel certificate) async {
    try {
      final response = await http.post(Uri.parse(endpoints.addCertificateUrl),
          headers: {
            'Content-Type':
                'application/json', // GÖNDERİLEN VERİ JSON FORMATINDA
          },
          body: jsonEncode(certificate.toJson()));

      print('İstek gönderildi: ${endpoints.addCertificateUrl}');
      print('İstek başlıkları: ${response.headers}');
      print('İstek gövdesi: ${response.body}');

      if (response.statusCode == 200) {
        print('Sertifika eklendi');
        return true;
      } else {
        print('Sertifika eklenemedi status code = ${response.statusCode}');
        print('Hata mesajı: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Hata: $e');
      return false;
    }
  }

  Future<void> deleteCertificate(int certificateId) async {
    final url = Uri.parse(
        '${endpoints.baseUrl}/Certificates/DeleteCertificate?certificateId=$certificateId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print("Sertifika Silindi");
    } else {
      print("sertifika silinirken hata oluştu :${response.statusCode}");
      throw Exception("Sertifika silinirken hata oluştu");
    }
  }
}