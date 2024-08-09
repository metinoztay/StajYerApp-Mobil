import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/User/models/ForgotPasswordRequestModel.dart';
import 'package:stajyer_app/User/models/ResetPasswordRequest.dart';

class ForgotPasswordService {
  final String baseUrl = 'http://stajyerapp.runasp.net/api';

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    final url = Uri.parse('$baseUrl/User/ForgotPassword');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      // Başarıyla gönderildi
      print('Success');
    } else {
      print("Kod gönderilemedi: ${response.body}");
      throw Exception('Failed to send password reset request');
    }
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    final url = Uri.parse('$baseUrl/User/ResetPassword');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      // Başarıyla şifre sıfırlandı
      print('Password reset successful');
    } else {
      print("Şifre sıfırlanamadı: ${response.body}");
      throw Exception('Failed to reset password');
    }
  }
}