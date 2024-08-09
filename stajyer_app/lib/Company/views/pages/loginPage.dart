import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/models/companyLoginModel.dart';
import 'package:stajyer_app/Company/services/api/companyLoginService.dart';
import 'package:stajyer_app/Company/views/components/createPasswordPopup.dart';
import 'package:stajyer_app/Company/views/pages/CompanyRegisterPage.dart';
import 'package:stajyer_app/Company/views/pages/GirisNavigation.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/pages/ForgotPassword.dart';
import 'package:stajyer_app/User/views/pages/homeNavigation.dart';

class CompanyLoginPage extends StatefulWidget {
  const CompanyLoginPage({super.key});

  @override
  State<CompanyLoginPage> createState() => _CompanyLoginPageState();
}

class _CompanyLoginPageState extends State<CompanyLoginPage> {
  bool obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final CompanyLoginService _loginService = CompanyLoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 355,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Card(
                    color: button,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text(
                            "StajYerApp Şirket Girişi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .blue, // Odaklanıldığında kenarlık rengi
                                    width:
                                        2.0, // Odaklanıldığında kenarlık kalınlığı
                                  ),
                                ),
                                hintText: "E-Mailinizi Giriniz",
                                filled: true,
                                fillColor: background,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors
                                        .blue, // Odaklanıldığında kenarlık rengi
                                    width:
                                        2.0, // Odaklanıldığında kenarlık kalınlığı
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(obscurePassword
                                      ? Icons.lock_open
                                      : Icons.lock),
                                ),
                                hintText: "Şifrenizi Giriniz",
                                filled: true,
                                fillColor: background,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0, bottom: 30, top: 5),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPassword()));
                                  },
                                  child: Text(
                                    "Şifremi Unuttum?",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30),
              child: SizedBox(
                width: 330,
                child: ElevatedButton(
                  onPressed: () async {
                    final loginModel = CompanyLoginModel(
                      email: _emailController.text,
                      password: _passwordController.text,
                      compUserId: 0, // Placeholder value
                      nameSurname: "", // Placeholder value
                      phone: "", // Placeholder value
                      taxNumber: "", // Placeholder value
                      taxCityId: 0, // Placeholder value
                      taxOfficeId: 0, // Placeholder value
                      isVerified: false, // Placeholder value
                      hasSetPassword: true, // Placeholder value
                    );

                    final result = await _loginService.login(loginModel);

                    if (result != null) {
                      if (result.hasSetPassword) {
                        // Anasayfa'ya yönlendirme
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GirisNavigation()),
                        );
                      } else {
                        // Şifre oluşturma popup'ı gösterme
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Şifre Oluştur'),
                              content: CreatePasswordPopup(),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('İptal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Şifre oluşturma işlemleri burada yapılabilir
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Kaydet'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      // Hata mesajı göster
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Giriş Başarısız Lütfen tekrar deneyin'),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ilanCard,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text("Giriş Yap"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Şirketler için",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanyRegisterPage()),
                      );
                    },
                    child: Text(
                      "Kayıt ol",
                      style: TextStyle(
                        color: button,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
