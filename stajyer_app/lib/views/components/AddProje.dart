import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/models/ProjectModel.dart';
import 'package:stajyer_app/services/api/ProjectService.dart';
import 'package:stajyer_app/utils/colors.dart';

// Bu fonksiyon, bir proje ekleme dialogunu gösterir ve ekleme işleminin sonucunu döndürür.
Future<bool> showAddProjectDialog(BuildContext context) async {
  // Formu ve TextEditingController'ları oluşturuyoruz
  final _formKey = GlobalKey<FormState>();
  final _proNameController = TextEditingController();
  final _proDescController = TextEditingController();
  final _proGithubController = TextEditingController();

  // Proje ekleme işlemini gerçekleştiren asenkron bir fonksiyon
  Future<bool> _addProject() async {
    // Formun geçerli olup olmadığını kontrol et
    if (_formKey.currentState!.validate()) {
      // SharedPreferences kullanarak kullanıcı ID'sini al
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      // Eğer kullanıcı ID'si yoksa, kullanıcıyı bilgilendir ve false döndür
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Kullanıcı ID bulunamadı, lütfen tekrar giriş yapın.')),
        );
        return false;
      }

      // Proje modeli oluştur
      final project = ProjectModel(
        userId: userId,
        proName: _proNameController.text,
        proDesc: _proDescController.text,
        proGithub: _proGithubController.text,
      );

      // Projeyi eklemeye çalış
      bool success = await ProjectService().AddProject(project);
      if (success) {
        // Başarıyla eklendiyse kullanıcıyı bilgilendir ve formu sıfırla
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Başarıyla eklendi')));
        _formKey.currentState!.reset();
        return true;
      } else {
        // Hata oluştuysa kullanıcıyı bilgilendir
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Proje eklenirken bir hata oluştu')),
        );
        return false;
      }
    }
    // Form geçerli değilse false döndür
    return false;
  }

  // Dialogu göster ve kullanıcının yanıtını döndür
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Yeni Proje Ekle'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Proje adı için TextFormField
              TextFormField(
                controller: _proNameController,
                decoration: InputDecoration(labelText: 'Proje Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proje adını girin';
                  }
                  return null;
                },
              ),
              // Proje açıklaması için TextFormField
              TextFormField(
                controller: _proDescController,
                decoration: InputDecoration(labelText: 'Proje Açıklaması'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proje açıklamasını girin';
                  }
                  return null;
                },
              ),
              // GitHub linki için TextFormField
              TextFormField(
                controller: _proGithubController,
                decoration: InputDecoration(labelText: 'GitHub Linki'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'GitHub linkini girin';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          // İptal butonu
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(context)
                .pop(false), // Popup'ı kapat ve false döndür
            child: Text(
              'İptal',
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Ekle butonu
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ilanCard),
            onPressed: () async {
              // Projeyi eklemeye çalış ve sonucu döndür
              bool added = await _addProject();
              Navigator.of(context)
                  .pop(added); // Popup'ı kapat ve ekleme sonucunu döndür
            },
            child: Text(
              'Ekle',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  ).then((result) => result ?? false); // Dialog kapandıktan sonra sonucu döndür
}