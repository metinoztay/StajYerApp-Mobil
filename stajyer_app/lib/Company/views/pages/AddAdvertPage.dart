import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/CompAdvModel.dart';
import 'package:stajyer_app/Company/services/api/CompanyAdvertService.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class AddAdvertPage extends StatefulWidget {
  @override
  _AddAdvertPageState createState() => _AddAdvertPageState();
}

class _AddAdvertPageState extends State<AddAdvertPage> {
  final _formKey = GlobalKey<FormState>();
  late int compUserId;
  final _advTitleController = TextEditingController();
  final _advAdressController = TextEditingController();
  final _advWorkTypeController = TextEditingController();
  final _advDepartmentController = TextEditingController();
  final _advExpirationDateController = TextEditingController();
  final _advPhotoController = TextEditingController();
  final _advAdressTitleController = TextEditingController();
  final _advJobDescController = TextEditingController();
  final _advQualificationsController = TextEditingController();
  final _advAddInformationController = TextEditingController();
  final _advPaymentInfoController = TextEditingController();
  String? _selectedWorkType;
  DateTime? _expFinishDate;
  final ImagePicker _picker = ImagePicker();

  String? advTitle;
  String? advAdress;
  String? advWorkType;
  String? advDepartment;
  DateTime advExpirationDate = DateTime.now();
  String? advPhoto;
  String? advAdressTitle;
  bool advPaymentInfo = false;
  String? advJobDesc;
  String? advQualifications;
  String? advAddInformation;
  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, bool isStart) async {
    FocusScope.of(context).requestFocus(FocusNode()); // Klavye kapanır
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _expFinishDate) {
      controller.text = "${pickedDate.toLocal()}".split(' ')[0];
      if (isStart) {
        _expFinishDate = pickedDate;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      compUserId = prefs.getInt('compUserId') ??
          0; // compUserId'yi SharedPreferences'tan al
    });
  }

  Future<void> _addPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      final url = await CompanyAdvertService().addAdvPhoto(image);
      if (url != null) {
        setState(() {
          _advPhotoController.text = url; // Resmin URL'sini form alanına ekle
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resim başarıyla yüklendi!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Resim yükleme başarısız!')),
        );
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CompAdvModel newAdvert = CompAdvModel(
        compUserId: compUserId,
        advTitle: _advTitleController.text,
        advAdress: _advAdressController.text,
        advWorkType: _selectedWorkType ?? "",
        advDepartment: _advDepartmentController.text,
        advExpirationDate: _expFinishDate ?? DateTime.now(),
        advPhoto: _advPhotoController.text,
        advAdressTitle: _advAdressTitleController.text,
        advPaymentInfo:
            _advAddInformationController.text == 'true' ? true : false,
        advJobDesc: _advJobDescController.text,
        advQualifications: _advQualificationsController.text,
        advAddInformation: _advAddInformationController.text,
      );

      CompanyAdvertService service = CompanyAdvertService();
      bool isAdded = await service.addAdvert(newAdvert);

      if (isAdded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlan başarıyla eklendi!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İlan eklenemedi!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _advPhotoController,
                decoration: InputDecoration(
                  labelText: 'İlan Fotoğrafı',
                  suffixIcon: IconButton(
                      icon: Icon(Icons.add_a_photo), onPressed: _addPhoto),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
              ),
              // İconButton(
              //   style: IconButton.styleFrom(
              //       backgroundColor: ilanCard, foregroundColor: Colors.white),
              //   onPressed: _addPhoto,
              //   icon: Icon(Icons.add_a_photo),
              //   child: Text('Resim Seç'),
              // ),

              TextFormField(
                controller: _advTitleController,
                decoration: InputDecoration(labelText: 'İlan Başlığı '),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _advAdressController,
                decoration: InputDecoration(labelText: 'Tam Adres'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
                minLines: 1,
                maxLines: 5, // Burada gerekli yüksekliği ayarlayabilirsiniz
              ),
              TextFormField(
                controller: _advAdressTitleController,
                decoration: InputDecoration(labelText: 'İl / Ilçe'),
                onSaved: (value) {
                  advAdressTitle = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Çalışma tipi',
                ),
                dropdownColor: Colors.white,
                icon: Icon(Icons.arrow_drop_down, color: ilanCard),
                iconSize: 24,
                value: _selectedWorkType,
                items: [
                  DropdownMenuItem(
                    value: 'Hibrit',
                    child: Row(
                      children: [
                        Icon(Icons.sync, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Hibrit', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Uzaktan',
                    child: Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Uzaktan', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Yüz yüze',
                    child: Row(
                      children: [
                        Icon(Icons.business, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Yüz yüze', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  _selectedWorkType = value;
                },
              ),
              TextFormField(
                controller: _advDepartmentController,
                decoration: InputDecoration(labelText: 'Departman'),
                onSaved: (value) {
                  advDepartment = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _advJobDescController,
                decoration: InputDecoration(labelText: 'İş Tanımı'),
                onSaved: (value) {
                  advJobDesc = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
                minLines: 1,
                maxLines: 20,
              ),
              TextFormField(
                controller: _advQualificationsController,
                decoration: InputDecoration(labelText: 'Yeterlilikler'),
                onSaved: (value) {
                  advQualifications = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
                minLines: 1,
                maxLines: 20,
              ),
              TextFormField(
                controller: _advAddInformationController,
                decoration: InputDecoration(labelText: 'İlan Detayı'),
                onSaved: (value) {
                  advAddInformation = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Başlık gerekli';
                  }
                  return null;
                },
                minLines: 1,
                maxLines: 20,
              ),
              TextFormField(
                controller: _advExpirationDateController,
                decoration: InputDecoration(
                  labelText: 'Son Başvuru Tarihi',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(
                        context, _advExpirationDateController, true),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'İlan tarihini giriniz';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ilanCard, foregroundColor: Colors.white),
                onPressed: _submitForm,
                child: Text('İlanı Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
