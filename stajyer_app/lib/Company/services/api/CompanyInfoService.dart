import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/AddCompanyModel.dart';
import 'package:stajyer_app/Company/models/Company.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/Company/services/Endpoints.dart';

class CompanyInfoService {
  //COMPANYUSER IDYE GÖRE BİLGİLERİ
  Future<Company> getCompanyInfoByCompUserId(int companyUserId) async {
    try {
      final response = await http.get(
        Uri.parse(Endpoints.GetCompanyByCompanyUserId + '/$companyUserId'),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        Company company = Company.fromJson(data);
        return company;
      } else {
        print('Failed to fetch company. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch company.');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to fetch company: $e');
    }
  }

  //COMPUSER BİR ŞİRKET EKLİYOR(İLAN EKLEYEBİLMEK İÇİN)

  Future<bool> AddCompany(AddCompanyModel newCompany) async {
    try {
      // URL'nin boş olup olmadığını kontrol edin
      if (newCompany.compLogo == null || newCompany.compLogo!.isEmpty) {
        print("Şirket logosu URL'si boş olamaz");
        return false;
      }

      final response = await http.post(
        Uri.parse(Endpoints.AddCompany),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newCompany.toJson()),
      );

      if (response.statusCode == 200) {
        print("Şirket eklendi");
        print(response.body);
        return true;
      } else {
        print("Şirket eklenirken hata = ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print(" hata $e");
      return false;
    }
  }

  //ŞİRKET LOGO EKLEME
  Future<String?> addCompLogo(int compId, File image) async {
    final uri = Uri.parse(
        'http://stajyerapp.runasp.net/api/Photo/UploadCompanyLogo/$compId');
    var request = http.MultipartRequest('POST', uri);

    // Dosyanın byte dizisini alıyoruz
    var bytes = await image.readAsBytes();

    // Dosyayı yüklemek için http.MultipartFile.fromBytes kullanıyoruz
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: image.path.split('/').last,
    ));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(String.fromCharCodes(responseData));
        return result['fileUrl']; // Eğer dönen veri JSON formatındaysa
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Upload failed: ${response.statusCode}, Response: $responseBody');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  Future<void> updateCompany(Company company) async {
    final url = Uri.parse(Endpoints.UpdateCompanyUrl);
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(company.toJson()),
      );
      if (response.statusCode == 200) {
        print("Sirket bilgileri güncellendi");
      } else {
        print("Sirket bilgileri güncellenemedi : ${response.statusCode}");
      }
    } catch (e) {
      print("Sirket bilgileri güncellenemedi : $e");
    }
  }
}
