import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/models/savingAddDeleteModel.dart';
import 'package:stajyer_app/services/endpoints.dart';

class SavingService {
  Future<http.Response> addSaving(SavingAddDeleteModel model) async {
    final url = Uri.parse(endpoints.UserSaveAndDeleteAdvert);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(model.toJson()),
    );

    return response;
  }

  Future<http.Response> deleteSaving(SavingAddDeleteModel model) async {
    final url = Uri.parse(endpoints.UserSaveAndDeleteAdvert);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(model.toJson()),
    );

    return response;
  }
}
