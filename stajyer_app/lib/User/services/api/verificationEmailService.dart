import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/User/models/verificationEmailModel.dart';

class VerificationService {
  Future<void> sendVerificationCode(String userId) async {
    final url = Uri.parse(
        'http://stajyerapp.runasp.net/api/Application/SendVerificationCode');
    final request = VerificationRequest(userId: userId);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()), // JSON verisini gönder
    );

    if (response.statusCode != 200) {
      print(
          'Failed to send verification code. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to send verification code');
    }
  }

  Future<void> verifyEmail(String userId, String verificationCode) async {
    final url =
        Uri.parse('http://stajyerapp.runasp.net/api/Application/VerifyEmail');
    final request =
        VerificationRequest(userId: userId, verificationCode: verificationCode);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()), // JSON verisini gönder
    );

    if (response.statusCode != 200) {
      print('Failed to verify email. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to verify email');
    }
  }
}
