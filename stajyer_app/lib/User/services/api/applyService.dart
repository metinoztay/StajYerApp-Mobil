import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/User/models/applyModel.dart';
import 'package:stajyer_app/User/services/endpoints.dart';

class ApplyService {
  Future<bool> sendApplication(ApplyModel applyModel) async {
    final url = Uri.parse(endpoints.Apply);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(applyModel.toJson()),  
    );  
 
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 400) {
      print("email onayı gerekli");
      return false;
    } 
    
    else {
      print('Başvuru gönderilemediii: ${response.body}');
      return false;
    }
  }

}

 