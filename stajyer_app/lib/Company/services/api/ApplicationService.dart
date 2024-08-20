import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stajyer_app/Company/models/AppUserModel.dart';
import 'package:stajyer_app/Company/services/Endpoints.dart';

//Bir ilana başvuran kişileri gösterme
class ApplicationService {
  Future<List<AppUserModel>> fetchApplicants(int advertId) async {
    final response =
        await http.get(Uri.parse('${Endpoints.ApplicationsByAdvId}/$advertId'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['\$values'];
      return body.map((dynamic item) => AppUserModel.fromJson(item)).toList();
    } else {
      throw Exception(
          'Başvuranlar yüklenirken bir sorun oluştu: ${response.statusCode}');
    }
  }
}
