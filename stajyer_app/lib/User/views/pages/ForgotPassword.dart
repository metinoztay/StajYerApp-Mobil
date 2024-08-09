import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/User/models/ForgotPasswordRequestModel.dart';
import 'package:stajyer_app/User/services/api/ForgotPasswordService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/pages/VerifyCode.dart';

// ForgotPassword sınıfı, StatefulWidget olarak tanımlanır
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController =
      TextEditingController(); // Email girişi için controller
  final ForgotPasswordService _userService =
      ForgotPasswordService(); // Şifre sıfırlama servisi

  // Şifre sıfırlama kodu göndermek için kullanılan metod
  Future<void> _sendResetCode() async {
    final email = _emailController.text
        .trim(); // Email girişinden gelen metni al ve boşlukları temizle
    if (email.isEmpty) {
      // Eğer email adresi boşsa hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen e-posta adresinizi giriniz')),
      );
      return;
    }

    try {
      final request = ForgotPasswordRequest(
          email: email); // ForgotPasswordRequest nesnesi oluştur
      await _userService
          .forgotPassword(request); // Şifre sıfırlama isteğini gönder
      final prefs = await SharedPreferences
          .getInstance(); // SharedPreferences örneğini al
      await prefs.setString(
          'resetEmail', email); // Email adresini SharedPreferences'a kaydet
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyCode(), // VerifyCode sayfasına yönlendir
        ),
      );
    } catch (e) {
      // Eğer API isteği başarısız olursa hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre sıfırlama isteği gönderilemedi: $e')),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
