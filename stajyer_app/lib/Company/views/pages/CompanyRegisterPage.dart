import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/models/City.dart';
import 'package:stajyer_app/Company/models/CompanyRegisterModel.dart';
import 'package:stajyer_app/Company/models/TaxOfiice.dart';
import 'package:stajyer_app/Company/services/api/CompanyRegisterService.dart';
import 'package:stajyer_app/Company/services/api/CityTaxService.dart';
import 'package:stajyer_app/Company/views/pages/loginPage.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class CompanyRegisterPage extends StatefulWidget {
  const CompanyRegisterPage({super.key});

  @override
  State<CompanyRegisterPage> createState() => _CompanyRegisterPageState();
}

class _CompanyRegisterPageState extends State<CompanyRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();
  final TextEditingController _taxCityIdController = TextEditingController();
  final TextEditingController _taxOfficeIdController = TextEditingController();

  List<City> _cities = [];
  City? _selectedCity;

  List<TaxOffice> _taxOffices = [];
  TaxOffice? _selectedTaxOffice;

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    try {
      final response = await CityTaxService.getCities();
      print(response); // Yanıtı kontrol etmek için
      setState(() {
        _cities = response;
      });
    } catch (e) {
      print('Failed to load cities: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şehirleri yüklerken bir hata oluştu')),
      );
    }
  }

  Future<void> _fetchTaxOffices(int cityId) async {
    try {
      final taxOffices = await CityTaxService.getTaxOffices(cityId);
      setState(() {
        _taxOffices = taxOffices;
      });
    } catch (e) {
      // Hata durumunda yapılacak işlemler
      print('Failed to load tax offices: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: button, // Arka plan rengi
              borderRadius: BorderRadius.circular(10), // Yuvarlak köşeler
            ),
            child: IconButton(
              icon: Icon(Icons.chevron_left, color: Colors.white),
              iconSize: 20,
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Geri butonuna basıldığında yapılacak işlemler
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0), // Soldan boşluk
                  child: Text(
                    "Kayıt Ol!",
                    style: TextStyle(
                      color: appbar,
                      fontSize: 24, // Başlık boyutu
                      fontWeight: FontWeight.bold, // Kalın başlık
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: GirisCard, // Arka plan rengi
                  ),
                  width: double.infinity, // Genişliği kapsayıcıya göre ayarla
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _nameSurnameController,
                          decoration: InputDecoration(
                            hintText: "İsim - Soyisim",
                            hintStyle: TextStyle(color: appbar),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen adınızı ve soyadınızı giriniz';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: "Şirket Telefon Numarası",
                            hintStyle: TextStyle(color: appbar),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen telefon numaranızı giriniz';
                            } else if (value.length < 10) {
                              return 'Geçerli bir telefon numarası giriniz';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Eposta",
                            hintStyle: TextStyle(color: appbar),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _taxNumberController,
                          decoration: InputDecoration(
                            hintText: "Vergi Numarası",
                            hintStyle: TextStyle(color: appbar),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen vergi numaranızı giriniz';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DropdownButtonFormField<City>(
                          value: _selectedCity,
                          hint: Text("Şehir Seçin"),
                          items: _cities.map((City city) {
                            return DropdownMenuItem<City>(
                              value: city,
                              child: Text(city.cityName ?? ""),
                            );
                          }).toList(),
                          onChanged: (City? newValue) {
                            setState(() {
                              _selectedCity = newValue;
                              _taxOffices =
                                  []; // Önceki vergi dairelerini temizle
                              _selectedTaxOffice = null;
                            });
                            if (newValue != null) {
                              _fetchTaxOffices(newValue
                                  .cityId); // Şehir ID'si ile vergi dairelerini çek
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Lütfen bir şehir seçin';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_selectedCity != null)
                        DropdownButtonFormField<TaxOffice>(
                          value: _taxOffices.contains(_selectedTaxOffice)
                              ? _selectedTaxOffice
                              : null,
                          hint: Text("Vergi Dairesi Seçin"),
                          items: _taxOffices.map((TaxOffice taxOffice) {
                            return DropdownMenuItem<TaxOffice>(
                              value: taxOffice,
                              child: Text(taxOffice.office ?? ""),
                            );
                          }).toList(),
                          onChanged: (TaxOffice? newValue) {
                            setState(() {
                              _selectedTaxOffice = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Lütfen bir vergi dairesi seçin';
                            }
                            return null;
                          },
                        ),
                      SizedBox(
                          height:
                              20), // TextFormField'lar ile buton arasında boşluk
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: button,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              CompanyRegisterModel newCompany =
                                  CompanyRegisterModel(
                                      nameSurname: _nameSurnameController.text,
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      taxNumber: _taxNumberController.text,
                                      taxCityId: _selectedCity!.cityId,
                                      taxOfficeId:
                                          _selectedTaxOffice!.taxOfficeId);

                              bool success = await CompanyRegisterService()
                                  .CreateCompanyUser(newCompany);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Başarıyla kaydolundu')),
                                );
                                _formKey.currentState!.reset();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CompanyLoginPage()),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('kaydolurken bir hata oluştu')),
                              );
                            }

                            // Login butonuna tıklama işlemleri
                          },
                          child: Text(
                            'Kayıt Ol',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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
