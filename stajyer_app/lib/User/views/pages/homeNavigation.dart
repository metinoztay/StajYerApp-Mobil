import 'package:flutter/material.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/appbar.dart';
import 'package:stajyer_app/User/views/components/navigationBar.dart';
import 'package:stajyer_app/User/views/pages/Profile.dart';
import 'package:stajyer_app/User/views/pages/companysPage.dart';
import 'package:stajyer_app/User/views/pages/homePage.dart';
import 'package:stajyer_app/User/views/pages/savedAdv.dart';

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

    return WillPopScope(
      //geriye gitmez
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: background,
        appBar: _selectedIndex == 3
            ? null
            : happbar(), //profilde başka appbar kullanıcaz
        body: pages[_selectedIndex],
        bottomNavigationBar: HomeNavBar(
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }
}
