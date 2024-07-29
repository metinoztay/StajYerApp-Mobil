// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:stajyer_app/models/loginModel.dart';
// import 'package:stajyer_app/services/endpoints.dart';

// class LoginService {

//   Future<bool> login(LoginModel loginModel) async {
//     final url = Uri.parse(Endpoints.login);
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(loginModel.toJson()),
//     );

//     if (response.statusCode == 200) {
//       // Login successful
//       return true;
//     } else {
//       // Login failed
//       return false;
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/models/loginModel.dart';
import 'package:stajyer_app/services/endpoints.dart';

class LoginService {
  Future<bool> login(LoginModel loginModel) async {
    final url = Uri.parse(Endpoints.login);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loginModel.toJson()),
    );

    if (response.statusCode == 200) {
      // Login successful
      return true;
    } else {
      // Print the error message for debugging
      print('Login failed: ${response.statusCode}, ${response.body}');
      // Login failed
      return false;
    }
  }
}
