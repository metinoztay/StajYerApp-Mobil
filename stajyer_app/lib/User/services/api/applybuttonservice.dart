import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/User/models/applybuttonmodel.dart';

class ApplyButtonService {
  final String baseUrl =
      'http://stajyerapp.runasp.net/api/Advert/GetUserIsApplied';

  Future<bool> sendApplyButtonRequest(ApplyButtonModel applyButtonModel) async {
    final url = Uri.parse(
        '$baseUrl/${applyButtonModel.userId}/${applyButtonModel.advertId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // JSON doğrudan bool döndürüyor ise
      return json.decode(response.body) as bool;
    } else {
      throw Exception('İstek gönderilemedi: ${response.statusCode}');
    }
  }
}
