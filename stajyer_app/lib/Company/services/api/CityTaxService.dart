import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stajyer_app/Company/models/City.dart';
import 'package:stajyer_app/Company/models/TaxOfiice.dart';
import 'package:stajyer_app/Company/services/Endpoints.dart';

class CityTaxService {
  static Future<List<City>> getCities() async {
    final response = await http.get(Uri.parse(Endpoints.ListCityUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // `$values` anahtarını kontrol et
      if (data['\$values'] == null) {
        throw Exception('Cities list is null');
      }

      final citiesJson = data['\$values'] as List<dynamic>;
      return citiesJson.map((json) => City.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cities');
    }
  }

  static Future<List<TaxOffice>> getTaxOffices(int cityId) async {
    final response = await http
        .get(Uri.parse('${Endpoints.ListTaxOfficeByCityIdUrl}/$cityId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // `$values` anahtarını kontrol et
      if (data['\$values'] == null) {
        throw Exception('Tax offices list is null');
      }

      final taxOfficesJson = data['\$values'] as List<dynamic>;
      return taxOfficesJson.map((json) => TaxOffice.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tax offices');
    }
  }
}
