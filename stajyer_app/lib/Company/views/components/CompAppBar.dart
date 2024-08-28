import 'package:flutter/material.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class CompAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CompAppBar({super.key, required this.title});

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
      child: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, // Geri butonunu kaldır
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: TextStyle(
                    color: button, fontSize: 25, fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: IconButton(
          //       onPressed: () {}, icon: Icon(Icons.notifications_none)),
          // )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
