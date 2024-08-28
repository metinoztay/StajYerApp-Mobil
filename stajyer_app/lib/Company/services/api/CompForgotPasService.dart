import 'package:stajyer_app/Company/models/CompForgetPasswordModel.dart';
import 'package:stajyer_app/Company/models/CompResetPasswordModel.dart';
import 'package:stajyer_app/Company/services/Endpoints.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CompForgotPasService {
  Future<void> compForgotPassword(CompForgotPasswordModel request) async {
    final url = Uri.parse(Endpoints.CompForgotPasswordUrl);
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()));

    if (response.statusCode == 200) {
      print("compuser şifremi unuttum başaılı");
    } else {
      print("Kod gönderilemedi: ${response.body}");
      throw Exception('Failed to send password reset request');
    }
  }

  Future<void> compResetPassword(CompResetPasswordModel request) async {
    final url = Uri.parse(Endpoints.CompResetPasswordUrl);
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()));
    if (response.statusCode == 200) {
      print("comp user şifresi başarıyla sıfırlandı");
    } else {
      print("comp user şifre sıfırlanamadı ${response.body}");
    }
  }
}
