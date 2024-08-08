import 'package:flutter/material.dart';
import 'package:stajyer_app/utils/colors.dart';
import 'package:stajyer_app/views/components/appbar.dart';
import 'package:stajyer_app/views/components/navigationBar.dart';
import 'package:stajyer_app/views/pages/Profile.dart';
import 'package:stajyer_app/views/pages/companysPage.dart';
import 'package:stajyer_app/views/pages/homePage.dart';
import 'package:stajyer_app/views/pages/savedAdv.dart';

class homeNavigation extends StatefulWidget {
  @override
  _homeNavigationState createState() => _homeNavigationState();
}

class _homeNavigationState extends State<homeNavigation> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(),
      CompanysPage(),
      SavedAdv(),
      Profile(),
    ];

    return Scaffold(
      backgroundColor: background,
      appBar: happbar(),
      body: pages[_selectedIndex],
      bottomNavigationBar: HomeNavBar(
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
