import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/companyLoginModel.dart';
import 'package:stajyer_app/Company/services/endpoints.dart';

class CompanyLoginService {
  Future<CompanyLoginModel?> login(CompanyLoginModel companyLoginModel) async {
    final url = Uri.parse(Endpoints.complogin);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(companyLoginModel.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final CompanyLoginModel user = CompanyLoginModel.fromJson(data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('compUserId', user.compUserId); // Kullanıcı ID saklandı

      // Login başarılı
      print('Login successful');
      print(user.compUserId);
      return user;
    } else {
      // Hata mesajını debug etmek için yazdır
      print('Login failed: ${response.statusCode}, ${response.body}');
      // Login başarısız
      return null;
    }
  }
}
