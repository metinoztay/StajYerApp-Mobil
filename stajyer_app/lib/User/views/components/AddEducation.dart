import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/User/models/EducationModel.dart';
import 'package:stajyer_app/User/services/api/EducationService.dart';
import 'package:stajyer_app/User/services/api/UnivercityService.dart';

Future<bool> showAddEducationDialog(BuildContext context) async {
  final _formKey = GlobalKey<FormState>();
  final _progIdController = TextEditingController();
  final _eduStartDateController = TextEditingController();
  final _eduFinishDateController = TextEditingController();
  final _eduGanoController = TextEditingController();
  final _eduSituationController = TextEditingController();
  final _eduDescController = TextEditingController();
  DateTime? _expStartDate;
  DateTime? _expFinishDate;
  String? _selectedSituaion;

  List<Map<String, dynamic>> universities = [];
  List<Map<String, dynamic>> programs = [];
  int? _selectedUniId;
  int? _selectedProgId;
  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = "${picked.toLocal()}".split(' ')[0];
      if (isStart) {
        _expStartDate = picked;
      } else {
        _expFinishDate = picked;
      }
    }
  }

  Future<void> _fetchData() async {
    try {
      final univercityService = UnivercityService();
      universities = await univercityService.getUniversities();
      programs = await univercityService.getPrograms();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veriler alınırken bir hata oluştu: $e')),
      );
      print('Veri alma hatası: $e'); // Hata mesajını loglayın
    }
  }

  Future<bool> _addEducation() async {
    if (_formKey.currentState!.validate()) {
      if (_expStartDate != null &&
          _expFinishDate != null &&
          _expFinishDate!.isBefore(_expStartDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Bitiş tarihi, başlangıç tarihinden önce olamaz")),
        );
        return false;
      }
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

      final education = EducationModel(
        eduId: 0,
        userId: userId,
        uniId:
            _selectedUniId ?? 0, // Eğer _selectedUniId null ise 0 kullanılıyor
        progId: _selectedProgId ?? 0,
        eduStartDate: _eduStartDateController.text,
        eduFinishDate: _eduFinishDateController.text,
        eduGano: double.tryParse(_eduGanoController.text),
        eduSituation: _selectedSituaion ?? "",
        eduDesc: _eduDescController.text,
      );

      bool success = await EducationService().AddEducation(education);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eğitim eklendi')),
        );
        _formKey.currentState!.reset();
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eğitim eklenemedi')),
        );
        return false;
      }
    }
    return false;
  }

  await _fetchData();

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Yeni Eğitim Ekle'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: SizedBox(
                    child: Autocomplete<String>(
                      displayStringForOption: (String option) =>
                          option, // <--- Add this
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return [];
                        }
                        return universities
                            .map(
                                (univercity) => univercity['uniName'] as String)
                            .where((uniName) => uniName
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()))
                            .toList() as Iterable<String>;
                      },
                      onSelected: (String selection) {
                        int selectedUniId = universities.firstWhere(
                            (univercity) =>
                                univercity['uniName'] == selection)['uniId'];
                        _selectedUniId = selectedUniId;
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Üniversite Seçiniz',
                          ),
                        );
                      },
                    ),
                  ),
                ),
                DropdownButtonFormField<int>(
                  isExpanded: true,
                  value: _selectedProgId,
                  hint: Text('Program Seçin'),
                  onChanged: (newValue) {
                    _selectedProgId = newValue;
                    (context as Element).markNeedsBuild(); // UI'yi güncelle
                  },
                  items: programs.map((program) {
                    return DropdownMenuItem<int>(
                      value: program['progId'],
                      child: Text(program['progName']),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: _eduStartDateController,
                  decoration: InputDecoration(
                    labelText: 'Başlangıç tarihi',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () =>
                          _selectDate(context, _eduStartDateController, true),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Başlangıç tarihini giriniz';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eduFinishDateController,
                  decoration: InputDecoration(
                    labelText: 'Bitiş tarihi',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () =>
                          _selectDate(context, _eduFinishDateController, false),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitiş tarihini giriniz';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eduGanoController,
                  decoration:
                      InputDecoration(labelText: 'Genel Not Ortalaması'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Genel not ortalaması gereklidir';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: "Durum"),
                  dropdownColor: Colors.white,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  iconSize: 24,
                  value: _selectedSituaion,
                  items: const [
                    DropdownMenuItem(
                      value: '1. Sınıf',
                      child: Row(
                        children: [
                          Text('1. Sınıf',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '2. Sınıf',
                      child: Row(
                        children: [
                          Text('2. Sınıf',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '3. Sınıf',
                      child: Row(
                        children: [
                          Text('3. Sınıf',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '4. Sınıf',
                      child: Row(
                        children: [
                          Text('4. Sınıf',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Mezun',
                      child: Row(
                        children: [
                          Text('Mezun', style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    _selectedSituaion = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Çalışma tipini seçiniz';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _eduDescController,
                  decoration: InputDecoration(labelText: 'Açıklama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Açıklama gereklidir';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              bool success = await _addEducation();
              Navigator.of(context).pop(success);
            },
            child: Text('Ekle'),
          ),
        ],
      );
    },
  ).then((result) => result ?? false);
}