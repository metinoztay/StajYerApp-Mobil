import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/models/Advertisement.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stajyer_app/Company/models/CompAdvModel.dart';
import 'package:stajyer_app/Company/services/Endpoints.dart';
import 'package:stajyer_app/Company/views/components/showAddAdvertInfo.dart';
import 'package:stajyer_app/Company/views/components/showAddCompanyDialog.dart';
import 'package:stajyer_app/Company/views/pages/AddCompanyPage.dart';

class CompanyAdvertService {
  Future<List<Advertisement>> fetchAdvertisementsByCompanyUserId(
      int companyUserId) async {
    final response = await http.get(
        Uri.parse('${Endpoints.ListAdvertByCompanyUserId}/$companyUserId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // JSON verisini Advertisement modeline dönüştür
      List<Advertisement> advertisements = (data['\$values'] as List)
          .map((ad) => Advertisement.fromJson(ad))
          .toList();
      return advertisements;
    } else {
      throw Exception('Failed to load advertisements');
    }
  }
  // ilan ekleme

  Future<bool> addAdvert(BuildContext context, CompAdvModel newAdvert) async {
    try {
      if (newAdvert.compUserId == null || newAdvert.compUserId == 0) {
        // Kullanıcı ID'si yoksa veya geçersizse hata döndür
        print("Geçersiz kullanıcı ID'si");
        return false;
      }

      final response = await http.post(
        Uri.parse(Endpoints.CompanyAddAdvert),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newAdvert.toJson()),
      );

      if (response.statusCode == 500) {
        // Şirket bulunamadıysa kullanıcıyı şirket ekleme popup'ı açılıyor...
        print("Şirket bulunamadı, şirket ekleme popup'ı açılıyor...");

        // Şirket ekleme popup'ını aç
        await showAddAdvertInfo(context);

        return false;
      } else if (response.statusCode == 200) {
        // İlan başarıyla eklendi
        print("İlan başarıyla eklendi");
        return true;
      } else {
        // Diğer hata durumları
        print("İlan eklenemedi status code = ${response.statusCode}");
        print('Hata Mesajı: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Hata: $e');
      return false;
    }
  }

// API base URL

  Future<void> updateAdvert(Advertisement advert) async {
    final url = Uri.parse(Endpoints.UpdateAdvUrl);

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(advert.toJson()),
      );

      if (response.statusCode == 200) {
        print('Advert updated successfully');
      } else {
        print('Failed to update advert: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating advert: $error');
    }
  }

  Future<String?> addAdvPhoto(File image) async {
    final uri =
        Uri.parse('http://stajyerapp.runasp.net/api/Photo/UploadAdvertPhoto');
    var request = http.MultipartRequest('POST', uri);
    var pic = http.MultipartFile.fromBytes(
      'file',
      await image.readAsBytes(),
      filename: image.path.split('/').last,
    );
    request.files.add(pic);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = json.decode(String.fromCharCodes(responseData));

        if (result.containsKey('fileUrl')) {
          return result['fileUrl'];
        } else {
          print('Yanıt JSON\'unda "fileUrl" bulunamadı.');
          return null;
        }
      } else {
        print('Upload failed: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        print('Response body: $responseBody');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  //İLAN SİLME
  Future<void> deleteAdvert(int advertId) async {
    final response =
        await http.delete(Uri.parse('${Endpoints.DeleteAdvertUrl}/$advertId'));
    if (response.statusCode == 200) {
      print("ilan silindi");
    } else {
      print('ilan silinirken hata oluştu : ${response.statusCode}');

      throw Exception("ilan silinirken hata oluştu");
    }
  }
}
