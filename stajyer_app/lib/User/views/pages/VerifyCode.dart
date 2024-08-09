import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/User/models/ForgotPasswordRequestModel.dart';
import 'package:stajyer_app/User/models/ResetPasswordRequest.dart';
import 'package:stajyer_app/User/services/api/ForgotPasswordService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stajyer_app/User/views/pages/CreateNewPassword.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({super.key});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final TextEditingController _codeController =
      TextEditingController(); // PIN kodu için kontrolcü
  final ForgotPasswordService _forgotPasswordService =
      ForgotPasswordService(); // API servislerini kullanmak için
  bool _isButtonDisabled =
      false; // Butonun devre dışı olup olmadığını kontrol eder
  Timer? _timer; // Zamanlayıcıyı tutar
  int _remainingTime =
      5; // Başlangıçta 5 dakika ayarlanmış, bu süreyi gösterecek

  // Doğrulama kodunu doğrulama işlemi
  Future<void> _verifyCode() async {
    final prefs = await SharedPreferences
        .getInstance(); // SharedPreferences örneğini alır
    final email =
        prefs.getString('resetEmail'); // Kayıtlı e-posta adresini alır
    final code = _codeController.text.trim(); // Kullanıcıdan alınan kodu alır

    if (email != null && code.isNotEmpty) {
      try {
        final request = ResetPasswordRequest(
            email: email,
            code: code,
            newPassword: ''); // Şifre sıfırlama isteği oluşturur
        await _forgotPasswordService
            .resetPassword(request); // Şifre sıfırlama işlemini gerçekleştirir

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNewPassword(
                email: email,
                code: code), // Şifre yenileme sayfasına yönlendirir
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Doğrulama kodu yanlış veya süresi dolmuş: $e')), // Hata durumunda kullanıcıya mesaj gösterir
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Lütfen doğrulama kodunu giriniz')), // Kod girilmemişse uyarı gösterir
      );
    }
  }

  // Doğrulama kodunu yeniden gönderme işlemi
  void _resendCode() async {
    setState(() {
      _isButtonDisabled = true; // Butonu devre dışı bırakır
      _remainingTime = 30; // 30 saniye
    });

    final prefs = await SharedPreferences
        .getInstance(); // SharedPreferences örneğini alır
    final email =
        prefs.getString('resetEmail'); // Kayıtlı e-posta adresini alır

    if (email != null) {
      final request = ForgotPasswordRequest(
          email: email); // Şifre sıfırlama isteği oluşturur
      try {
        await _forgotPasswordService
            .forgotPassword(request); // Kod yeniden gönderilir
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Kod gönderilemedi: $e')), // Hata durumunda kullanıcıya mesaj gösterir
        );
      }
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--; // Kalan süreyi bir saniye azaltır
        } else {
          _isButtonDisabled = false; // Süre dolduğunda butonu tekrar aktif eder
          _timer?.cancel(); // Zamanlayıcıyı iptal eder
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Widget silindiğinde zamanlayıcıyı iptal eder
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