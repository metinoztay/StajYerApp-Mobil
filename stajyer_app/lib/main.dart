import 'package:flutter/material.dart';
import 'package:stajyer_app/utils/colors.dart';
import 'package:stajyer_app/views/components/navigationBar.dart';
import 'package:stajyer_app/views/pages/examplelistpage.dart';
import 'package:stajyer_app/views/pages/homeNavigation.dart';
import 'package:stajyer_app/views/pages/homePage.dart';
import 'package:stajyer_app/views/pages/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: button),
          useMaterial3: true,
        ),
       home: SplashScreen());
       // home: AdvertListScreen());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(),
      ),
    );
  }
}
