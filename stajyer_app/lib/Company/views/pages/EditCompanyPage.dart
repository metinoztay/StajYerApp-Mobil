import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/Company.dart';
import 'package:stajyer_app/Company/services/api/CompanyInfoService.dart';
import 'package:stajyer_app/Company/views/pages/loginPage.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class EditCompanyPage extends StatefulWidget {
  const EditCompanyPage({super.key});

  @override
  State<EditCompanyPage> createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  Company? company;
  bool _isNewImage = false; // Yeni resim yüklendiğinde true yapılacak
  bool _isFirstLoad = true; // İlk yükleme kontrolü

  final ImagePicker _picker = ImagePicker();
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _compNameController;
  late TextEditingController _compEmailController;
  late TextEditingController _compAddressController;
  late TextEditingController _compAdressTitleController;
  late TextEditingController _compSektorController;
  late TextEditingController _compWebSiteController;
  late TextEditingController _compLinkedinController;
  late TextEditingController _compDescController;
  late TextEditingController _compEmployeeCountController;
  late TextEditingController _compLogoController;
  late TextEditingController _compFoundDateController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _getCompanyInfo();
  }

  void _initializeControllers() {
    _compNameController = TextEditingController();
    _compEmailController = TextEditingController();
    _compAddressController = TextEditingController();
    _compAdressTitleController = TextEditingController();
    _compSektorController = TextEditingController();
    _compWebSiteController = TextEditingController();
    _compLinkedinController = TextEditingController();
    _compDescController = TextEditingController();
    _compEmployeeCountController = TextEditingController();
    _compLogoController = TextEditingController();
    _compFoundDateController = TextEditingController();
  }

  @override
  void dispose() {
    _compNameController.dispose();
    _compEmailController.dispose();
    _compAddressController.dispose();
    _compAdressTitleController.dispose();
    _compSektorController.dispose();
    _compWebSiteController.dispose();
    _compLinkedinController.dispose();
    _compDescController.dispose();
    _compEmployeeCountController.dispose();
    _compLogoController.dispose();
    _compFoundDateController.dispose();
    super.dispose();
  }

  Future<void> _getCompanyInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? compUserId = prefs.getInt('compUserId');

    if (compUserId != null) {
      try {
        CompanyInfoService compService = CompanyInfoService();
        Company fetchedCompany =
            await compService.getCompanyInfoByCompUserId(compUserId);
        setState(() {
          company = fetchedCompany;
          isLoading = false;
          _updateControllers(fetchedCompany);
          _isFirstLoad = false; // İlk yükleme tamamlandı
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog('Güncelleme sırasında bir hata oluştu.');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Şirket bilgileri alınamadı.');
    }
  }

  Future<File> _getFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return file;
    } else {
      throw Exception('Dosya bulunamadı');
    }
  }

  void _updateControllers(Company fetchedCompany) {
    _compDescController.text = fetchedCompany.compDesc!;
    _compEmailController.text = fetchedCompany.compContactMail!;
    _compAddressController.text = fetchedCompany.compAdress!;
    _compAdressTitleController.text = fetchedCompany.compAddressTitle!;
    _compSektorController.text = fetchedCompany.compSektor!;
    _compWebSiteController.text = fetchedCompany.compWebSite!;
    _compLinkedinController.text = fetchedCompany.comLinkedin!;
    _compEmployeeCountController.text =
        fetchedCompany.compEmployeeCount.toString();
    _compLogoController.text = fetchedCompany.compLogo!;
    _compFoundDateController.text = fetchedCompany.compFoundationYear!;
    _compNameController.text = fetchedCompany.compName!;
  }

  Future<void> _selectPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      final url =
          await CompanyInfoService().addCompLogo(company!.compId, image);

      if (url != null && url.isNotEmpty) {
        setState(() {
          _compLogoController.text = url; // URL'yi sakla
          _isNewImage = true; // Yeni resim yüklendi
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resim başarıyla yüklendi!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resim yükleme başarısız!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim seçilmedi!')),
      );
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('compUserId');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CompanyLoginPage()));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Güncellendi!'),
          content: Text('Şirket bilgileri başarıyla güncellendi!'),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hata'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateCompany() async {
    if (_formKey.currentState!.validate()) {
      final updatedCompany = Company(
        compUserId: company!.compUserId,
        compId: company!.compId,
        compName: _compNameController.text,
        compContactMail: _compEmailController.text,
        compAdress: _compAddressController.text,
        compAddressTitle: _compAdressTitleController.text,
        compSektor: _compSektorController.text,
        compWebSite: _compWebSiteController.text,
        comLinkedin: _compLinkedinController.text,
        compDesc: _compDescController.text,
        compEmployeeCount: int.parse(_compEmployeeCountController.text),
        compLogo: _compLogoController.text,
        compFoundationYear: _compFoundDateController.text,
      );

      try {
        await CompanyInfoService().updateCompany(updatedCompany);
        _showSuccessDialog();
      } catch (e) {
        _showErrorDialog('Güncelleme sırasında bir hata oluştu.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Şirket Bilgilerini Düzenle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 5),
                            _compLogoController.text.isNotEmpty
                                ? _isFirstLoad
                                    ? FutureBuilder<File>(
                                        future:
                                            _getFile(_compLogoController.text),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasData) {
                                              return Image.file(
                                                snapshot.data!,
                                                height: 150,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Text(
                                                      'Dosya bulunamadı');
                                                },
                                              );
                                            } else {
                                              return Text('Dosya bulunamadı');
                                            }
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      )
                                    : Image.network(
                                        _compLogoController.text,
                                        height: 150,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Text('Resim yüklenemedi');
                                        },
                                      )
                                : Text('Mevcut resim yok'),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ilanCard,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _selectPhoto,
                          child: Text('Resim Seç'),
                        ),
                      ),
                      TextFormField(
                        controller: _compNameController,
                        decoration: InputDecoration(labelText: 'Şirket Adı'),
                        validator: (value) =>
                            value!.isEmpty ? 'Şirket adı gerekli' : null,
                      ),
                      TextFormField(
                        controller: _compEmailController,
                        decoration:
                            InputDecoration(labelText: 'Şirket E-Posta'),
                        validator: (value) => EmailValidator.validate(value!)
                            ? null
                            : 'Geçerli bir e-posta girin',
                      ),
                      TextFormField(
                        controller: _compAddressController,
                        decoration: InputDecoration(labelText: 'Şirket Adresi'),
                        validator: (value) =>
                            value!.isEmpty ? 'Şirket adresi gerekli' : null,
                      ),
                      TextFormField(
                        controller: _compAdressTitleController,
                        decoration: InputDecoration(labelText: 'İl/İlçe'),
                      ),
                      TextFormField(
                        controller: _compSektorController,
                        decoration:
                            InputDecoration(labelText: 'Şirket Sektörü'),
                        validator: (value) =>
                            value!.isEmpty ? 'Sektör bilgisi gerekli' : null,
                      ),
                      TextFormField(
                        controller: _compWebSiteController,
                        decoration:
                            InputDecoration(labelText: 'Şirket Web Sitesi'),
                        validator: (value) =>
                            value!.isEmpty ? 'Web sitesi gerekli' : null,
                      ),
                      TextFormField(
                        controller: _compLinkedinController,
                        decoration:
                            InputDecoration(labelText: 'Şirket LinkedIn'),
                      ),
                      TextFormField(
                        controller: _compDescController,
                        decoration:
                            InputDecoration(labelText: 'Şirket Açıklaması'),
                        maxLines: null, // Uzun metinler için sınırsız satır
                        keyboardType: TextInputType
                            .multiline, // Metin girişi için çok satırlı klavye
                      ),
                      TextFormField(
                        controller: _compEmployeeCountController,
                        decoration:
                            InputDecoration(labelText: 'Çalışan Sayısı'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Çalışan sayısı gerekli' : null,
                      ),
                      TextFormField(
                        controller: _compFoundDateController,
                        decoration: InputDecoration(labelText: 'Kuruluş Yılı'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Kuruluş yılı gerekli' : null,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ilanCard,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _updateCompany,
                          child: Text('Güncelle'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _logout,
                          child: Text('Çıkış Yap'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
