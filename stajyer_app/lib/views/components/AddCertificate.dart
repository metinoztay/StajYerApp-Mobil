import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/models/CertificateModel.dart';
import 'package:stajyer_app/services/api/CertificateService.dart';

Future<bool> showAddCertificateDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  final _certNameController = TextEditingController();
  final _cerCompanyNameController = TextEditingController();
  final _certDescController = TextEditingController();
  final _certDateController = TextEditingController();
  DateTime? _certDate;
  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, bool isStart) async {
    FocusScope.of(context).requestFocus(FocusNode()); // Klavye kapanır
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _certDate) {
      controller.text = "${pickedDate.toLocal()}".split(' ')[0];
      if (isStart) {
        _certDate = pickedDate;
      }
    }
  }

  Future<bool> _addCertificate() async {
    if (_formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Kullanıcı ID bulunamadı, lütfen tekrar giriş yapın.')),
        );
        return false;
      }

      final certificate = CertificateModel(
        userId: userId,
        certName: _certNameController.text,
        cerCompanyName: _cerCompanyNameController.text, // Eklenmiş
        certDesc: _certDescController.text,
        certDate: _certDateController.text,
      );

      bool success = await CertificateService().AddCertificate(certificate);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sertifika eklendi')),
        );
        _formKey.currentState!.reset();
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sertifika eklenemedi')),
        );
        return false;
      }
    }
    return false;
  }

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Yeni Sertifika Ekle'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _certNameController,
                decoration: InputDecoration(labelText: 'Sertifika Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sertifika adını girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cerCompanyNameController, // Eklenmiş
                decoration: InputDecoration(labelText: 'Sertifika Şirket Adı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sertifika şirket adını girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _certDescController,
                decoration: InputDecoration(labelText: 'Sertifika Açıklaması'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sertifika açıklamasını girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _certDateController,
                decoration: InputDecoration(
                  labelText: 'Sertifika Tarihi',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () =>
                        _selectDate(context, _certDateController, true),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sertifika tarihini girin';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              bool added = await _addCertificate();
              Navigator.of(context).pop(added);
            },
            child: Text('Ekle'),
          ),
        ],
      );
    },
  ).then((result) => result ?? false);
}