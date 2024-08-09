import 'package:flutter/material.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/SirketCard.dart';

class CompanysPage extends StatefulWidget {
  const CompanysPage({super.key});

  @override
  State<CompanysPage> createState() => _CompanysPageState();
}

class _CompanysPageState extends State<CompanysPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 25.0, top: 20),
        //   child: Text(
        //     "Şirketler",
        //     style: TextStyle(
        //         color: button, fontSize: 25, fontWeight: FontWeight.bold),
        //   ),
        // ),
       SirketCard(),
      ],
    );
  }
}