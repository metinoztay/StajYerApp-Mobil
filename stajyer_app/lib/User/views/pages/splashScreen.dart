import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/pages/homeNavigation.dart';
import 'package:stajyer_app/User/views/pages/homePage.dart';
import 'package:stajyer_app/User/views/pages/loginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserFromDevice();
  }

  void _checkUserFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    print(userId);
    if (userId != null) {
      // Kullanıcı ID bulunduysa doğrudan ana sayfaya yönlendir
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => homeNavigation()),
      );
    } else {
      // Kullanıcı ID bulunamadıysa login sayfasına yönlendir
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "StajyerApp",
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 90.0),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}