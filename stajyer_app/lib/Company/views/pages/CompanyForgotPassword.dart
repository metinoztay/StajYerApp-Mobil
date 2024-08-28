import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/CompForgetPasswordModel.dart';
import 'package:stajyer_app/Company/services/api/CompForgotPasService.dart';
import 'package:stajyer_app/Company/views/pages/CompVerfiyCode.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class CompanyForgotPassword extends StatefulWidget {
  const CompanyForgotPassword({super.key});

  @override
  State<CompanyForgotPassword> createState() => _CompanyForgotPasswordState();
}

class _CompanyForgotPasswordState extends State<CompanyForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final CompForgotPasService _compService = CompForgotPasService();

  Future<void> _sendResetCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lütfen e-posta adresinizi giriniz')));
      return;
    }

    try {
      final request = CompForgotPasswordModel(email: email);
      await _compService.compForgotPassword(request);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('resetCompEmail', email);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CompVerifyCode()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sifre sıfırlama istegi gönderilemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200.0, left: 20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop(); // Geri dönme işlemi
                    },
                  ),
                  Text(
                    'Şifremi Unuttum',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 40, right: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: GirisCard, // Giriş kartının rengi
                ),
                width: 300,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: 'Email adresinizi giriniz',
                          focusColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: GirisCard)),
                          fillColor: background,
                          filled: true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
                margin: const EdgeInsets.only(left: 120),
                child: ElevatedButton(
                  onPressed: _sendResetCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ilanCard,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Text('Kod Gönder'),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
