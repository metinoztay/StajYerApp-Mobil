import 'package:flutter/material.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class AddCompanyPage extends StatefulWidget {
  const AddCompanyPage({super.key});

  @override
  State<AddCompanyPage> createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _foundationYearController =
      TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Dialog'u build metodundan hemen sonra göstermek için bir delay kullanıyoruz
    Future.delayed(Duration.zero, () {
      _showAddCompanyDialog();
    });
  }

  void _showAddCompanyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Şirket Ekle',
            style: TextStyle(color: Colors.amber),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Şirket Adı'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen şirket adını giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _foundationYearController,
                    decoration: InputDecoration(labelText: 'Kuruluş Yılı'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen kuruluş yılını giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _websiteController,
                    decoration: InputDecoration(labelText: 'Web Sitesi'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen web sitesini giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'İletişim E-posta'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen iletişim e-posta adresini giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Adres'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen adresi giriniz';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _sectorController,
                    decoration: InputDecoration(labelText: 'Sektör'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lütfen sektörü giriniz';
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
                Navigator.of(context).pop(); // Dialog'u kapat
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  _saveCompany();
                  Navigator.of(context).pop(); // Dialog'u kapat
                }
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  void _saveCompany() {
    print('Şirket Adı: ${_nameController.text}');
    print('Kuruluş Yılı: ${_foundationYearController.text}');
    print('Web Sitesi: ${_websiteController.text}');
    print('İletişim E-posta: ${_emailController.text}');
    print('Adres: ${_addressController.text}');
    print('Sektör: ${_sectorController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Şirket Ekleme Sayfası')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showAddCompanyDialog,
          child: Text('Şirket Ekle'),
        ),
      ),
    );
  }
}
