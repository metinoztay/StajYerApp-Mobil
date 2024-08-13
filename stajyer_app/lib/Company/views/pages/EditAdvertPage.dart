import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stajyer_app/Company/models/Advertisement.dart';
import 'package:stajyer_app/Company/services/api/CompanyAdvertService.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class EditAdvertPage extends StatefulWidget {
  final Advertisement advert;

  const EditAdvertPage({super.key, required this.advert});

  @override
  _EditAdvertPageState createState() => _EditAdvertPageState();
}

class _EditAdvertPageState extends State<EditAdvertPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _titleController;
  late TextEditingController _addressController;
  late TextEditingController _workTypeController;
  late TextEditingController _departmentController;
  late TextEditingController _expirationDateController;
  late TextEditingController _photoController;
  late TextEditingController _addressTitleController;
  late TextEditingController _jobDescController;
  late TextEditingController _qualificationsController;
  late TextEditingController _addInfoController;
  late TextEditingController _appCountController;
  String? _selectedWorkType;
  DateTime? _expFinishDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.advert.advTitle);
    _addressController = TextEditingController(text: widget.advert.advAdress);
    _workTypeController =
        TextEditingController(text: widget.advert.advWorkType);
    _departmentController =
        TextEditingController(text: widget.advert.advDepartment);
    _expirationDateController = TextEditingController(
        text: widget.advert.advExpirationDate.toIso8601String());
    _photoController = TextEditingController(text: widget.advert.advPhoto);
    _addressTitleController =
        TextEditingController(text: widget.advert.advAdressTitle);
    _jobDescController = TextEditingController(text: widget.advert.advJobDesc);
    _qualificationsController =
        TextEditingController(text: widget.advert.advQualifications);
    _addInfoController =
        TextEditingController(text: widget.advert.advAddInformation);
    _appCountController =
        TextEditingController(text: widget.advert.advAppCount);
    _selectedWorkType =
        widget.advert.advWorkType; // Mevcut çalışma tipi değerini ayarla
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _workTypeController.dispose();
    _departmentController.dispose();
    _expirationDateController.dispose();
    _photoController.dispose();
    _addressTitleController.dispose();
    _jobDescController.dispose();
    _qualificationsController.dispose();
    _addInfoController.dispose();
    _appCountController.dispose();
    super.dispose();
  }

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

  Future<void> _selectPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      final url = await CompanyAdvertService().addAdvPhoto(image);
      if (url != null) {
        setState(() {
          _photoController.text = url; // Resmin URL'sini form alanına ekle
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

  void _updateAdvert() async {
    if (_formKey.currentState!.validate()) {
      final updatedAdvert = Advertisement(
        advertId: widget.advert.advertId,
        compId: widget.advert.compId,
        advTitle: _titleController.text,
        advAdress: _addressController.text,
        advWorkType: _selectedWorkType ?? widget.advert.advWorkType,
        advDepartment: _departmentController.text,
        advExpirationDate: _expFinishDate ?? widget.advert.advExpirationDate,
        advIsActive: widget.advert.advIsActive,
        advPhoto: _photoController.text,
        advAdressTitle: _addressTitleController.text,
        advPaymentInfo: widget.advert.advPaymentInfo,
        advJobDesc: _jobDescController.text,
        advQualifications: _qualificationsController.text,
        advAddInformation: _addInfoController.text,
      );

      await CompanyAdvertService().updateAdvert(updatedAdvert);

      Navigator.pop(
          context, true); // Güncellenmiş olduğunu belirtmek için true gönder
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İlan başarıyla güncellendi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlan Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5), //mevcut resim
                      _photoController.text.isNotEmpty
                          ? Image.network(
                              _photoController.text,
                              height: 150,
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
                    onPressed: _selectPhoto, //resmi değiştirme
                    child: Text('Resim Seç'),
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'İlan Başlığı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Başlık gerekli';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Tam Adres'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Adres gerekli';
                    }
                    return null;
                  },
                  minLines: 1,
                  maxLines: 5,
                ),
                // Eski resim URL'si burada gösteriliyor

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Çalışma tipi',
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down, color: ilanCard),
                  iconSize: 24,
                  value:
                      _selectedWorkType, // Mevcut çalışma tipi burada seçili olarak geliyor
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
                          Text('Uzaktan',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Yerinde',
                      child: Row(
                        children: [
                          Icon(Icons.apartment, color: Colors.black),
                          SizedBox(width: 10),
                          Text('Yerinde',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedWorkType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Çalışma tipi gerekli';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _expirationDateController,
                  readOnly: true,
                  onTap: () =>
                      _selectDate(context, _expirationDateController, true),
                  decoration: InputDecoration(
                    labelText: 'Bitiş Tarihi',
                    suffixIcon: Icon(Icons.calendar_today, color: ilanCard),
                  ),
                ),
                TextFormField(
                  controller: _departmentController,
                  decoration: InputDecoration(labelText: 'Departman'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Departman gerekli';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressTitleController,
                  decoration: InputDecoration(labelText: 'Adres Başlığı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Adres başlığı gerekli';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _jobDescController,
                  decoration: InputDecoration(labelText: 'İş Tanımı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'İş tanımı gerekli';
                    }
                    return null;
                  },
                  minLines: 1,
                  maxLines: 20,
                ),
                TextFormField(
                  controller: _qualificationsController,
                  decoration: InputDecoration(labelText: 'Aranan Nitelikler'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nitelikler gerekli';
                    }
                    return null;
                  },
                  minLines: 1,
                  maxLines: 20,
                ),
                TextFormField(
                  controller: _addInfoController,
                  decoration: InputDecoration(labelText: 'Ek Bilgiler'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ek bilgiler gerekli';
                    }
                    return null;
                  },
                  minLines: 1,
                  maxLines: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ilanCard,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _updateAdvert,
                    child: Text('İlanı Güncelle'),
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
