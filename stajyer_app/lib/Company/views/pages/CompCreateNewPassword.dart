import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/models/CompResetPasswordModel.dart';
import 'package:stajyer_app/Company/services/api/CompForgotPasService.dart';
import 'package:stajyer_app/Company/views/pages/loginPage.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class CompCreateNewPassword extends StatefulWidget {
  final String email;
  final String code;
  const CompCreateNewPassword(
      {super.key, required this.email, required this.code});

  @override
  State<CompCreateNewPassword> createState() => _CompCreateNewPasswordState();
}

class _CompCreateNewPasswordState extends State<CompCreateNewPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();
  bool _showPassword = false;
  final CompForgotPasService _compForgotPasService = CompForgotPasService();

  Future<void> _resetPassword() async {
    final newPassword = _passwordController.text.trim();
    if (newPassword.isNotEmpty &&
        _confirmedPasswordController.text.trim() == newPassword) {
      try {
        final request = CompResetPasswordModel(
            email: widget.email, code: widget.code, newPassword: newPassword);
        await _compForgotPasService.compResetPassword(request);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sifre sıfırlandı')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CompanyLoginPage(), // LoginPage sayfasına yönlendir
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sifre sıfırlanamadi: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sifreler uyusmuyor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Kolonun, gerekli alandan fazla yer kaplamasını önler
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150.0, left: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
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
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: GirisCard,
                ),
                width: double.infinity, // Ekranın tamamını kaplar
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Kolonun, gerekli alandan fazla yer kaplamasını önler
                  children: [
                    Text(
                      'Yeni şifre oluştur',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: background,
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Yeni Şifre',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmedPasswordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: background,
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Şifreyi tekrar giriniz',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: background,
                          activeColor: ilanCard,
                          value: _showPassword,
                          onChanged: (value) {
                            setState(() {
                              _showPassword = value!;
                            });
                          },
                        ),
                        Text('Şifreyi görüntüle'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ilanCard,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text('Kaydet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
