import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/models/ExperienceModel.dart';
import 'package:stajyer_app/services/api/CityService.dart';
import 'package:stajyer_app/services/api/ExperienceService.dart';
import 'package:stajyer_app/utils/colors.dart';

// Bu fonksiyon, kullanıcıya yeni bir deneyim ekleme için bir diyalog gösterir.
Future<bool> showAddExperienceDialog(BuildContext context) async {
  // Form ve kontrolcüler için gerekli değişkenler tanımlanır.
  final _formKey = GlobalKey<FormState>();
  final _expPositionController = TextEditingController();
  final _expCompanyController = TextEditingController();
  final _expCityController = TextEditingController();
  final _expWorkTypeController = TextEditingController();
  final _expDescController = TextEditingController();
  final _expStartController = TextEditingController();
  final _expFinishController = TextEditingController();
  DateTime? _expStartDate;
  DateTime? _expFinishDate;
  String? _selectedworkType;

  List<Map<String, dynamic>> cities = [];
  int? _selectedCityId;

  // Tarih seçimi için bir yardımcı fonksiyon.
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

  // Şehirleri API'den çekmek için bir fonksiyon.
  Future<void> _fetchCities() async {
    try {
      final cityService = CityService();
      cities = await cityService.getCitys();
    } catch (e) {
      print('Sehirler alınırken bir hata oluştu: $e');
    }
  }

  // Deneyim ekleme işlemini gerçekleştiren fonksiyon.
  Future<bool> _addExperience() async {
    if (_formKey.currentState!.validate()) {
      // Başlangıç ve bitiş tarihlerini kontrol et.
      if (_expStartDate != null &&
          _expFinishDate != null &&
          _expFinishDate!.isBefore(_expStartDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Bitiş tarihi, başlangıç tarihinden önce olamaz")),
        );
        return false;
      }

      // Kullanıcı ID'sini SharedPreferences'tan al.
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId'); // Kaydedilen ID'yi kullan.

      if (userId == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Kullanıcı ID bulunamadı")));
        return false;
      }

      // Yeni deneyim oluştur ve API'ye gönder.
      final experience = ExperienceModel(
          userId: userId,
          expDesc: _expDescController.text,
          expPosition: _expPositionController.text,
          expCompanyName: _expCompanyController.text,
          expCityId: _selectedCityId ?? 0,
          expStartDate: _expStartController.text,
          expFinishDate: _expFinishController.text,
          expWorkType: _selectedworkType ?? "");

      bool success =
          await ExperienceService().AddExperience(experience); // Deneyimi ekle.

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Deneyim eklendi")),
        );
        _formKey.currentState!.reset();
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Deneyim eklenemedi")),
        );
        return false;
      }
    }
    return false;
  }

  // Şehirleri API'den çek.
  await _fetchCities();

  // Kullanıcıya deneyim ekleme diyalog penceresini göster.
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Yeni Deneyim Ekle'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Deneyim açıklaması için form alanı.
                TextFormField(
                  controller: _expDescController,
                  decoration: InputDecoration(labelText: 'Açıklama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deneyiminizi açıklayınız';
                    }
                    return null;
                  },
                ),
                // Pozisyon için form alanı.
                TextFormField(
                  controller: _expPositionController,
                  decoration: InputDecoration(labelText: 'Pozisyon'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Hangi pozisyonda çalıştığınızı giriniz.';
                    }
                    return null;
                  },
                ),
                // Şirket adı için form alanı.
                TextFormField(
                  controller: _expCompanyController,
                  decoration: InputDecoration(labelText: 'Şirket'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şirket adını giriniz';
                    }
                    return null;
                  },
                ),
                // Şehir seçimi için Autocomplete widget'ı.
                Container(
                  child: SizedBox(
                    child: Autocomplete<String>(
                      // Seçenekleri ekranda nasıl göstereceğimizi belirliyor.
                      displayStringForOption: (String option) => option,

                      // Kullanıcı yazdıkça bu fonksiyon çalışır ve öneri listesini oluşturur.
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        // Eğer kullanıcı bir şey yazmamışsa boş bir liste döndürür.
                        if (textEditingValue.text == '') {
                          return [];
                        }

                        // 'cities' listesindeki şehir isimlerini döndürür.
                        // Kullanıcının yazdığı metni içeren şehirleri filtreler.
                        return cities
                            .map((city) => city['cityName'] as String)
                            .where((cityName) => cityName
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()))
                            .toList() as Iterable<String>;
                      },

                      // Kullanıcı bir seçenek seçtiğinde bu fonksiyon çağrılır.
                      onSelected: (String selection) {
                        // Seçilen şehir ismine göre şehir ID'sini bulur ve `_selectedCityId` değişkenine atar.
                        int selectedCityId = cities.firstWhere(
                            (city) => city['cityName'] == selection)['cityId'];
                        _selectedCityId = selectedCityId;
                      },

                      // `TextFormField` ile arama kutusunun görünümünü oluşturur.
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Şehir seçiniz',
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Başlangıç tarihi için form alanı.
                TextFormField(
                  controller: _expStartController,
                  decoration: InputDecoration(
                    labelText: 'Başlangıç tarihi',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () =>
                          _selectDate(context, _expStartController, true),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Başlangıç tarihini giriniz';
                    }
                    return null;
                  },
                ),
                // Bitiş tarihi için form alanı.
                TextFormField(
                  controller: _expFinishController,
                  decoration: InputDecoration(
                    labelText: 'Bitiş tarihi',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () =>
                          _selectDate(context, _expFinishController, false),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bitiş tarihini giriniz';
                    }
                    return null;
                  },
                ),
                // Çalışma tipi seçimi için DropdownButtonFormField.
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Çalışma tipi',
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down, color: ilanCard),
                  iconSize: 24,
                  value: _selectedworkType,
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
                      value: 'Yüz yüze',
                      child: Row(
                        children: [
                          Icon(Icons.business, color: Colors.black),
                          SizedBox(width: 10),
                          Text('Yüz yüze',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    _selectedworkType = value;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Diğer sayfaya geri dön.
            },
            child: Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () async {
              bool success = await _addExperience(); // Deneyim ekle.
              if (success) {
                Navigator.of(context)
                    .pop(true); // Başarılı ise sayfayı kapat ve true döndür.
              }
            },
            child: Text('Kaydet'),
          ),
        ],
      );
    },
  ).then((result) => result ?? false);
}