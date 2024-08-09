import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/User/models/UserModel.dart';
import 'package:stajyer_app/User/models/loginModel.dart';
import 'package:stajyer_app/User/services/endpoints.dart';

class LoginService {
  Future<bool> login(LoginModel loginModel) async {
    final url = Uri.parse(endpoints.login);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loginModel.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final UserModel user = UserModel.fromJson(data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.userId!); //kullanıcı id saklandı

      // Login başarılı
      print('Login successful');
      return true;
    } else {
      // Print the error message for debugging
      print('Login failed: ${response.statusCode}, ${response.body}');
      // Login failed
      return false;
    }
  }
}