
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/User/models/CompanyAdvModel.dart';
import 'package:stajyer_app/User/models/homeAdvModel.dart';
import 'package:stajyer_app/User/services/endpoints.dart';
  import 'package:stajyer_app/User/models/CompanyAdvModel.dart';

class Companydetailservice {

Future<List<CompanyAdvModel>> getAdvertsByCompanyId(int id) async {
    final response = await http.get(
      Uri.parse(endpoints.getAdvByCompIdUrl + '/$id'),
    );

    if (response.statusCode == 200) {
      // Yanıtı JSON olarak çöz
      Map<String, dynamic> body = json.decode(response.body);

      // İlanları al
      List<dynamic> valuesList = body['\$values'];

      // İlanları CompanyAdvModel nesnelerine dönüştür
      List<CompanyAdvModel> adverts =
          valuesList.map((item) => CompanyAdvModel.fromJson(item)).toList();

      return adverts;
    } else {
      throw Exception('İlanlar yüklenirken sorun oluştu');
    }
  }
}