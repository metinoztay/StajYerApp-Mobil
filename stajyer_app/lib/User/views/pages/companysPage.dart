import 'package:flutter/material.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/SirketCard.dart';

class CompanysPage extends StatefulWidget {
  const CompanysPage({super.key});

  @override
  State<CompanysPage> createState() => _CompanysPageState();
}

class _CompanysPageState extends State<CompanysPage> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Şirket ara...",
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: SirketCard(searchText: searchText),
        ),
      ],
    );
  }
}
