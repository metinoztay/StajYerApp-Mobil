import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:stajyer_app/User/models/UserRegisterModel.dart';
import 'package:stajyer_app/User/services/api/UserRegisterService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isMale = true;
  bool obscurePassword = true;
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                SizedBox(
                  height: 10,
                ),
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "isim",
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
                              return 'Lütfen adınızı giriniz';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _surnameController,
                          decoration: InputDecoration(
                            hintText: "soyisim",
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
                              return 'Lütfen soyadınızı giriniz';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _mailController,
                          decoration: InputDecoration(
                            hintText: "mail",
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
                            if (!EmailValidator.validate(value!))
                              return "Geçerli bir eposta giriniz!";
                            if (value == null || value.isEmpty)
                              return "Bu alan boş geçilemez!";
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _birthController,
                          decoration: InputDecoration(
                            hintText: "doğum tarihi",
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
                          onTap: () async {
                            FocusScope.of(context)
                                .requestFocus(FocusNode()); // Klavye kapanır
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null &&
                                pickedDate != _selectedDate) {
                              setState(() {
                                _selectedDate = pickedDate;
                                _birthController.text =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text("Erkek"), //kadın 0 erkek 1
                                leading: Radio<bool>(
                                  value: true,
                                  groupValue: isMale,
                                  onChanged: (value) {
                                    setState(() {
                                      isMale = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text("Kadın"),
                                leading: Radio<bool>(
                                  value: false,
                                  groupValue: isMale,
                                  onChanged: (value) {
                                    setState(() {
                                      isMale = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                            hintText: "şifre",
                            hintStyle: TextStyle(color: appbar),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              icon: Icon(
                                color: appbar,
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
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
                            if (value == null || value.isEmpty)
                              return "Bu alan boş geçilemez!";

                            if (value.length < 3)
                              return "3 karakterden küçük değer girilemez!";
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: 20), // TextFormField'lar ile buton arasında boşluk
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: button,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        UserRegisterModel newUser = UserRegisterModel(
                          uname: _nameController.text,
                          usurname: _surnameController.text,
                          uemail: _mailController.text,
                          upassword: _passwordController.text,
                          ubirthdate: _birthController.text,
                          ugender: isMale,
                        );

                        bool success =
                            await UserRegisterService().CreateUser(newUser);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Başarıyla kaydolundu')),
                          );
                          _formKey.currentState!.reset();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('kaydolurken bir hata oluştu')),
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
        ),
      ),
    );
  }
}
