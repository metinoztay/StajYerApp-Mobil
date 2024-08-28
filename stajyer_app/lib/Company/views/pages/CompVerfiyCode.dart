import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/CompForgetPasswordModel.dart';
import 'package:stajyer_app/Company/models/CompResetPasswordModel.dart';
import 'package:stajyer_app/Company/services/api/CompForgotPasService.dart';
import 'package:stajyer_app/Company/views/pages/CompCreateNewPassword.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class CompVerifyCode extends StatefulWidget {
  const CompVerifyCode({super.key});

  @override
  State<CompVerifyCode> createState() => _CompVerifyCodeState();
}

class _CompVerifyCodeState extends State<CompVerifyCode> {
  final TextEditingController _codeController = TextEditingController();
  final CompForgotPasService _compForgotPasService = CompForgotPasService();
  bool _isButtonDisabled = false;
  Timer? _timer;
  int _remainingTime = 5;

  Future<void> _verifyCode() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('resetCompEmail');
    final code = _codeController.text.trim();
    if (email != null && code.isNotEmpty) {
      try {
        final request =
            CompResetPasswordModel(email: email, code: code, newPassword: '');
        await _compForgotPasService.compResetPassword(request);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompCreateNewPassword(
                email: email,
                code: code), // Şifre yenileme sayfasına yönlendirir
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Doğrulama kodu yanlış veya güresi dolmuş: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen kodu giriniz')),
      );
    }
  }

  void _resendCode() async {
    setState(() {
      _isButtonDisabled = true;
      _remainingTime = 30;
    });
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('resetCompEmail');
    if (email != null) {
      final request = CompForgotPasswordModel(email: email);
      try {
        await _compForgotPasService.compForgotPassword(request);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sifre sıfırlama istegi gönderilemedi: $e')),
        );
      }
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isButtonDisabled = false;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    'Şifremi unuttum',
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: GirisCard,
                  ),
                  width: 500,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sıfırla',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('mailinize gönderilen sıfırlama kodunu giriniz',
                          style: TextStyle(color: Colors.black)),
                      const SizedBox(height: 20),
                      PinCodeTextField(
                        controller: _codeController,
                        appContext: context,
                        length: 6, // 6 haneli PIN kodu
                        onChanged: (value) {},
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          activeColor: Colors.black,
                          inactiveColor: Colors.black,
                          selectedColor: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: _isButtonDisabled ? null : _resendCode,
                        child: Text(
                          _isButtonDisabled
                              ? 'Sıfırlama kodu $_remainingTime saniye içinde tekrar gonderilecektir' // Buton devre dışıysa kalan süreyi gösterir
                              : 'Henüz sıfırlama kodu gelmedi mi? Yeniden gönder', // Buton aktifse metni gösterir
                          style: TextStyle(color: ilanCard),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode, // Kod doğrulama işlemini başlatır
              style: ElevatedButton.styleFrom(
                backgroundColor: ilanCard,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('Sıfırla'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
