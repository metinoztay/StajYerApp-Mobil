import 'dart:convert';

import 'package:stajyer_app/User/models/ProjectModel.dart';
import 'package:stajyer_app/User/models/UserModel.dart';
import 'package:stajyer_app/User/services/endpoints.dart';
import 'package:http/http.dart' as http;

// ProjectService sınıfı, projelerle ilgili API işlemlerini gerçekleştirir
class ProjectService {
  // Belirli bir kullanıcı ID'sine sahip projeleri almak için kullanılan metod
  Future<List<ProjectModel>> getUserProjects(int userId) async {
    final String apiUrl =
        '${endpoints.GetProjectByUserIdUrl}/$userId'; // API URL'sini kullanıcı ID'si ile oluştur

    try {
      // HTTP GET isteği gönderiyoruz
      final response = await http.get(Uri.parse(apiUrl));

      // HTTP yanıtının durum kodunu kontrol et
      if (response.statusCode == 200) {
        // Başarılı yanıt durumunda, yanıt gövdesini JSON'a dönüştür
        print('API Yanıtı: ${response.body}');
        Map<String, dynamic> data = json.decode(response.body);
        // JSON verilerini ProjectModel nesnelerine dönüştür ve döndür
        return ProjectModel.fromJsonList(data);
      } else {
        // API hatası durumunda hata mesajı yazdır ve bir exception fırlat
        print('API Hatası: ${response.statusCode} - ${response.body}');
        throw Exception('Projeler alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      // Hata durumunda hata mesajı yazdır ve bir exception fırlat
      print('Hata: $e');
      throw Exception('Projeler alınırken bir hata oluştu: $e');
    }
  }

  // Yeni bir proje eklemek için kullanılan metod
  Future<bool> AddProject(ProjectModel project) async {
    try {
      // HTTP POST isteği gönderiyoruz
      final response = await http.post(
        Uri.parse(endpoints.addProjectUrl),
        headers: {
          'Content-Type':
              'application/json', // Gönderilen verinin JSON formatında olduğunu belirtir
        },
        body: jsonEncode(project
            .toJson()), // ProjectModel nesnesini JSON formatına dönüştür ve gövdeye ekle
      );

      // İstek ile ilgili bilgileri yazdır
      print('İstek gönderildi: ${endpoints.addProjectUrl}');
      print('İstek başlıkları: ${response.headers}');
      print('İstek gövdesi: ${response.body}');

      // Yanıt durum kodunu kontrol et
      if (response.statusCode == 200) {
        // Başarı durumunda true döndür
        print("proje eklendi");
        return true;
      } else {
        // Hata durumunda hata mesajını yazdır ve false döndür
        print('proje eklenemedi status code = ${response.statusCode}');
        print('Hata mesajı: ${response.body}');
      }
    } catch (e) {
      // Hata durumunda hata mesajını yazdır ve false döndür
      print('hata: $e');
    }
    return false; // Varsayılan olarak false döndür
  }

  Future<void> deleteProject(int projectId) async {
    final url = Uri.parse(
        '${endpoints.baseUrl}/Project/DeleteProject?projectId=$projectId');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Project successfully deleted.');
    } else {
      print('Failed to delete project. Status code: ${response.statusCode}');
      throw Exception('Failed to delete project');
    }
  }
}