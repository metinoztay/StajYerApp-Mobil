import 'package:flutter/material.dart';
import 'package:stajyer_app/Company/views/components/CompAppBar.dart';
import 'package:stajyer_app/Company/views/components/GirisNavbar.dart';
import 'package:stajyer_app/Company/views/pages/AddAdvertPage.dart';
import 'package:stajyer_app/Company/views/pages/CompanyProfile.dart';
import 'package:stajyer_app/Company/views/pages/HomePage.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/pages/homePage.dart';

class GirisNavigation extends StatefulWidget {
  const GirisNavigation({super.key});

  @override
  State<GirisNavigation> createState() => _GirisNavigationState();
}

class _GirisNavigationState extends State<GirisNavigation> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      CompanyHomePage(),
      AddAdvertPage(),
      CompanyProfile(),
    ];

    List<String> titles = [
      "İlanlarım",
      "İlan Ekle",
      "Profil",
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CompAppBar(title: titles[_selectedIndex]),
        backgroundColor: background,
        body: pages[_selectedIndex],
        bottomNavigationBar: GirisNavbar(
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }
}
