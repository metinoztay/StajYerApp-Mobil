import 'package:flutter/material.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/appbar.dart';

class GirisNavbar extends StatefulWidget {
  final Function(int) onTabSelected;
  const GirisNavbar({super.key, required this.onTabSelected});

  @override
  State<GirisNavbar> createState() => _GirisNavbarState();
}

class _GirisNavbarState extends State<GirisNavbar> {
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
            offset: Offset(0, 1),
          )
        ],
      ),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'İlanlarım'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'İlan Ekle'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
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
