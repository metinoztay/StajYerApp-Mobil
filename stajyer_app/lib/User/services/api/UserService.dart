import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/User/models/UserModel.dart';
import 'package:stajyer_app/User/services/endpoints.dart';

class UserService {
  Future<UserModel> getUserById(int userId) async {
    try {
      final response = await http.get(
        Uri.parse(endpoints.getUserByIdUrl + '/$userId'),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        UserModel user = UserModel.fromJson(data);
        return user;
      } else {
        print('Failed to fetch user. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch user');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<void> updateUser(int userId, Map<String, dynamic> updatedData) async {
    final headers = {'Content-Type': 'application/json'};

    // Varsayılan ve geçerli değerler ataması yapalım
    final phone = updatedData['uphone'] !=
            'Şirketlerin siz ulaşabilmesi için telefon numarası girmelisiniz.'
        ? updatedData['uphone']
        : '1234567890'; // Geçerli bir telefon numarası
    final birthdate =
        updatedData['ubirthdate'] ?? '2024-08-12'; // Geçerli bir tarih formatı

    final body = jsonEncode({
      'userId': userId,
      'uname': updatedData['uname'] ?? '',
      'usurname': updatedData['usurname'] ?? '',
      'uemail': updatedData['uemail'] ?? '',
      'upassword': updatedData['upassword'] ?? '',
      'uphone': phone,
      'ubirthdate': birthdate,
      'ugender': updatedData['ugender'] ?? true,
      'ulinkedin': updatedData['ulinkedin'] ?? UserModel.defaultLinkedin,
      'ucv': updatedData['ucv'] ?? UserModel.defaultCv,
      'ugithub': updatedData['ugithub'] ?? UserModel.defaultGithub,
      'udesc': updatedData['udesc'] ?? UserModel.defaultDesc,
      'uprofilephoto': updatedData['uprofilephoto'] ?? '',
    });

    print('Güncelleme Body: $body');

    try {
      final response = await http.put(
        Uri.parse('http://stajyerapp.runasp.net/api/User/UpdateUser'),
        headers: headers,
        body: body,
      );

      print('HTTP Response Status: ${response.statusCode}');
      print('HTTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Kullanıcı başarıyla güncellendi.');
      } else if (response.statusCode == 204) {
        print('Güncelleme başarılı, ancak yanıt gövdesi boş.');
      } else {
        print('Güncelleme başarısız. Status code: ${response.statusCode}');
        print('Yanıt: ${response.body}');
      }
    } catch (e) {
      print('Bir hata oluştu: $e');
    }
  }

  Future<String?> uploadUserPhoto(int userId, File image) async {
    final uri = Uri.parse(
        'http://stajyerapp.runasp.net/api/Photo/UploadUserPhoto/${userId}');
    var request = http.MultipartRequest('POST', uri);
    var pic = http.MultipartFile.fromBytes(
      'file',
      await image.readAsBytes(),
      filename: image.path.split('/').last,
    );
    request.files.add(pic);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(String.fromCharCodes(responseData));
        return result['fileUrl'];
      } else {
        print('Upload failed: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}
