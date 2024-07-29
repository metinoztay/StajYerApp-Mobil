

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stajyer_app/models/loginModel.dart';
import 'package:stajyer_app/services/loginService.dart';
import 'package:stajyer_app/utils/colors.dart';
import 'package:stajyer_app/views/pages/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LoginService _loginService = LoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 355,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Card(
                    color: button,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text(
                            "StajYerApp giriş yap",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _emailController, // Email controller eklendi
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
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
                            controller: _passwordController, // Password controller eklendi
                            obscureText: obscurePassword, // Şifre gizleme
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
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
                                  onPressed: () {},
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
                        final loginModel = LoginModel(
                          uemail: _emailController.text,
                          upassword: _passwordController.text
                        );

                        final success = await _loginService.login(loginModel);

                        if (success) {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => HomePage()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Giriş Başarısız Lütfen tekrar dene'),
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ilanCard,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text("Giriş Yap"),
                      ))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hesabın yok mu",
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Kayıt Ol!",
                      style:
                          TextStyle(color: button, fontWeight: FontWeight.bold),
                    ))
              ],
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
                       
                      },
                      child: Text(
                        "Giriş Yap!",
                        style: TextStyle(
                            color: button, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
