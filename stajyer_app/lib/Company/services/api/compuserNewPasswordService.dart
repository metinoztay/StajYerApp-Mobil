import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/Company/models/compuserNewPasswordModel.dart';

class CompUserNewPasswordService {
  final String apiUrl = 'http://stajyerapp.runasp.net/api/CompanyUser/NewPassword';

  Future<void> changePassword(CompUserNewPasswordModel model) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      // Başarıyla güncellendi
      print('Şifre değiştirildi.');
    } else {
      // Hata durumunu ele al
      throw Exception('Şifre değiştirme başarısız. Durum kodu: ${response.statusCode}');
    }
  }
}
