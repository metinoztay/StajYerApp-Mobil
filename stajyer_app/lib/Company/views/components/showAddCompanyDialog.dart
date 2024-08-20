import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/AddCompanyModel.dart';
import 'package:stajyer_app/Company/models/Company.dart';
import 'package:stajyer_app/Company/services/api/CompanyInfoService.dart';
import 'package:stajyer_app/User/utils/colors.dart';

Future<bool> showAddCompanyDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _companyFoundDateController = TextEditingController();
  final _companyDescController = TextEditingController();
  final _compWebSiteController = TextEditingController();
  final _compContactmailController = TextEditingController();
  final _compAdressController = TextEditingController();
  final _compAdressTitleController = TextEditingController();
  final _compSektorController = TextEditingController();
  final _compLogoController = TextEditingController();
  final _compLinkedinController = TextEditingController();
  final _compEmployeeCountController = TextEditingController();

  Future<void> _addPhoto() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _compLogoController.text =
          pickedFile.path; // Resim yolunu controller'a at
    }
  }

  Future<bool> _addCompany() async {
    if (_formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final compUserId = prefs.getInt('compUserId');
      if (compUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Kullanıcı ID bulunamadı, lütfen tekrar giriş yapın.')),
        );
        return false;
      }
      final company = AddCompanyModel(
        compUserId: compUserId,
        compName: _companyNameController.text,
        compFoundationYear: _companyFoundDateController.text,
        compDesc: _companyDescController.text,
        compWebSite: _compWebSiteController.text,
        compContactMail: _compContactmailController.text,
        compAdress: _compAdressController.text,
        compAddressTitle: _compAdressTitleController.text,
        compSektor: _compSektorController.text,
        compLogo: _compLogoController.text,
        comLinkedin: _compLinkedinController.text,
        compEmployeeCount: int.parse(_compEmployeeCountController.text),
      );

      bool success = await CompanyInfoService().AddCompany(company);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Şirket eklendi')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Şirket eklenirken hata')),
        );
        return false;
      }
    }

    return false;
  }

  final bool added = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        width: 900,
        child: AlertDialog(
          backgroundColor: background,
          title: Center(
              child: Text(
            'Şirket Ekle',
            style: TextStyle(
                color: appbar, fontSize: 25, fontWeight: FontWeight.bold),
          )),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Daha sonra şirket bilgilerini profil sayfasında düzenleyebilirsiniz...'),
                  TextFormField(
                    controller: _companyNameController,
                    decoration: InputDecoration(
                      labelText: 'Şirket Adı',
                      prefixIcon: Icon(Icons.business), // Şirket simgesi
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şirket adını giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _compLogoController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(Icons.add_a_photo), onPressed: _addPhoto),
                      labelText: 'Şirket Logosu',
                      prefixIcon: Icon(Icons.image), // Resim simgesi
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şirket logosunu giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _companyDescController,
                    decoration: InputDecoration(
                      labelText: 'Şirket hakkında bilgi veriniz',
                      prefixIcon: Icon(Icons.info), // Bilgi simgesi
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şirket hakkında bilgi veriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _companyFoundDateController,
                    decoration: InputDecoration(
                      labelText: 'Şirket Kuruluş Yılı',
                      prefixIcon: Icon(Icons.calendar_today), // Takvim simgesi
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şirket kuruluş yılı giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _compContactmailController,
                    decoration: InputDecoration(
                      labelText: 'İletişim Maili',
                      prefixIcon: Icon(Icons.email), // E-posta simgesi
                    ),
                    validator: (value) {
                      if (!EmailValidator.validate(value!)) {
                        return "Geçerli bir e-posta giriniz!";
                      }
                      if (value == null || value.isEmpty) {
                        return "Bu alan boş geçilemez!";
                      }
                    },
                  ),
                  TextFormField(
                    controller: _compAdressController,
                    decoration: InputDecoration(
                      labelText: 'Adres',
                      prefixIcon: Icon(Icons.location_on), // Konum simgesi
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şirketin adresini giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _compAdressTitleController,
                    decoration: InputDecoration(
                      labelText: 'İl/İlçe',
                      prefixIcon: Icon(Icons.place), // Yer simgesi
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şirket İl/İlçe giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _compSektorController,
                    decoration: InputDecoration(
                      labelText: 'Sektör',
                      prefixIcon: Icon(Icons.business_center), // Sektör simgesi
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şirketin sektörünü giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _compWebSiteController,
                    decoration: InputDecoration(
                      labelText: 'Web Sitesi',
                      prefixIcon: Icon(Icons.web), // Web sitesi simgesi
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şirketin web sitesini giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _compLinkedinController,
                    decoration: InputDecoration(
                      labelText: 'Linkedin Adresi',
                      prefixIcon: Icon(Icons.link), // Bağlantı simgesi
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şirketin Linkedin adresini giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _compEmployeeCountController,
                    decoration: InputDecoration(
                      labelText: 'Çalışan Sayısı',
                      prefixIcon: Icon(Icons.group), // Grup simgesi
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şirketin çalışan sayısını giriniz';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Popup'ı kapat ve false döndür
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool added = await _addCompany();
                Navigator.of(context)
                    .pop(added); // Popup'ı kapat ve sonucu döndür
              },
              child: Text('Kaydet'),
            ),
          ],
        ),
      );
    },
  );

  return added; // Sonucu döndür
}
