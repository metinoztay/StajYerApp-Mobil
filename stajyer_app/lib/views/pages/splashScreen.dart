import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stajyer_app/utils/colors.dart';
import 'package:stajyer_app/views/pages/loginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   void initState() {
     super.initState();
       Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()), 
      );
    });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("StajyerApp",
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