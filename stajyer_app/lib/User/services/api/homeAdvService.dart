// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:stajyer_app/models/CompanyAdvModel.dart';
// import 'package:stajyer_app/models/homeAdvModel.dart';
// import 'package:stajyer_app/services/endpoints.dart';

// class AdvertService {
//   Future<List<HomeAdvModel>> fetchAdverts() async {
//     final response = await http.get(Uri.parse(endpoints.homelistadv));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> body = json.decode(response.body);

//       // Referansları çöz
//       resolveReferences(body);

//       if (body['\$values'] != null) {
//         List<dynamic> advertList = body['\$values'];
//         List<HomeAdvModel> adverts = advertList.map((dynamic item) => HomeAdvModel.fromJson(item)).toList();
//         return adverts;
//       } else {
//         throw Exception('No adverts found');
//       }
//     } else {
//       throw Exception('Failed to load adverts');
//     }
//   }
// }

// void resolveReferences(Map<String, dynamic> json) {
//   Map<String, dynamic> idMap = {};

//   // İlk geçiş: tüm $id değerlerini topla
//   void collectIds(Map<String, dynamic> item) {
//     if (item.containsKey("\$id")) {
//       idMap[item["\$id"]] = item;
//     }
//     item.forEach((key, value) {
//       if (value is Map<String, dynamic>) {
//         collectIds(value);
//       } else if (value is List) {
//         value.forEach((element) {
//           if (element is Map<String, dynamic>) {
//             collectIds(element);
//           }
//         });
//       }
//     });
//   }

//   // İkinci geçiş: tüm $ref değerlerini çöz
//   void resolveRefs(Map<String, dynamic> item) {
//     if (item.containsKey("\$ref")) {
//       String refId = item["\$ref"];
//       if (idMap.containsKey(refId)) {
//         item.clear();
//         item.addAll(idMap[refId]);
//       }
//     }
//     item.forEach((key, value) {
//       if (value is Map<String, dynamic>) {
//         resolveRefs(value);
//       } else if (value is List) {
//         value.forEach((element) {
//           if (element is Map<String, dynamic>) {
//             resolveRefs(element);
//           }
//         });
//       }
//     });
//   }

//   collectIds(json);
//   resolveRefs(json);



//   Future<List<CompanyAdvModel>> getAdvertsByCompanyId(int id) async {
//     final response = await http.get(
//       Uri.parse(endpoints.getAdvByCompIdUrl + '/$id'),
//     );

//     if (response.statusCode == 200) {
//       // Yanıtı JSON olarak çöz
//       Map<String, dynamic> body = json.decode(response.body);

//       // İlanları al
//       List<dynamic> valuesList = body['\$values'];

//       // İlanları CompanyAdvModel nesnelerine dönüştür
//       List<CompanyAdvModel> adverts =
//           valuesList.map((item) => CompanyAdvModel.fromJson(item)).toList();

//       return adverts;
//     } else {
//       throw Exception('İlanlar yüklenirken sorun oluştu');
//     }
//   }

// }



import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/User/models/CompanyAdvModel.dart';
import 'package:stajyer_app/User/models/homeAdvModel.dart';
import 'package:stajyer_app/User/services/endpoints.dart';

class AdvertService {
  
  Future<List<HomeAdvModel>> fetchAdverts() async {
    final response = await http.get(Uri.parse(endpoints.homelistadv));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);

      // Referansları çöz
      resolveReferences(body);

      if (body['\$values'] != null) {
        List<dynamic> advertList = body['\$values'];
        List<HomeAdvModel> adverts = advertList.map((dynamic item) => HomeAdvModel.fromJson(item)).toList();
        return adverts;
      } else {
        throw Exception('No adverts found');
      }
    } else {
      throw Exception('Failed to load adverts');
    }
  }
}

void resolveReferences(Map<String, dynamic> json) {
  Map<String, dynamic> idMap = {};

  // İlk geçiş: tüm $id değerlerini topla
  void collectIds(Map<String, dynamic> item) {
    if (item.containsKey("\$id")) {
      idMap[item["\$id"]] = item;
    }
    item.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        collectIds(value);
      } else if (value is List) {
        value.forEach((element) {
          if (element is Map<String, dynamic>) {
            collectIds(element);
          }
        });
      }
    });
  }

  // İkinci geçiş: tüm $ref değerlerini çöz
  void resolveRefs(Map<String, dynamic> item) {
    if (item.containsKey("\$ref")) {
      String refId = item["\$ref"];
      if (idMap.containsKey(refId)) {
        item.clear();
        item.addAll(idMap[refId]);
      }
    }
    item.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        resolveRefs(value);
      } else if (value is List) {
        value.forEach((element) {
          if (element is Map<String, dynamic>) {
            resolveRefs(element);
          }
        });
      }
    });
  }

  collectIds(json);
  resolveRefs(json);


  //COMP İDYE GÖRE ADV
}