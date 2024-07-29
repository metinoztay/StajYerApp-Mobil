import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stajyer_app/models/UserRegisterModel.dart';
import 'package:stajyer_app/services/Endpoints.dart';

class UserRegisterService {
  Future<bool> CreateUser(UserRegisterModel newUser) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.registerUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newUser.toJson()),
      );

      if (response.statusCode == 200) {
        print("kullanıcı eklendi");
        return true;
      } else {
        print('kullanıcı eklenemedi status code = ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // İstek sırasında bir hata oluşursa, hatayı yazdırıyoruz
      print('hata: $e');
      return false;
    }
  }
}
