import 'package:flutter/material.dart';
import 'package:stajyer_app/utils/colors.dart';
import 'package:stajyer_app/views/components/appbar.dart';

class HomeNavBar extends StatefulWidget {
  final Function(int) onTabSelected;

  const HomeNavBar({super.key, required this.onTabSelected});

  @override
  State<HomeNavBar> createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 1), // sadece alt tarafına gölge
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Companies'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            appbartitle(index);
          });
          widget.onTabSelected(index);
        },
        selectedItemColor: button,
        unselectedItemColor: Colors.grey,
      ),
    );
  }




}



