import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/Company.dart';
import 'package:stajyer_app/Company/services/api/CompanyInfoService.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  Company? company;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCompanyInfo();
  }

  Future<void> _getCompanyInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? compuserId = prefs.getInt('compUserId');

    if (compuserId != null) {
      try {
        CompanyInfoService compService = CompanyInfoService();
        Company fetchedCompany =
            await compService.getCompanyInfoByCompUserId(compuserId);
        setState(() {
          company = fetchedCompany;
          isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kullanıcı bilgileri alınamadı'),
          ),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kullanıcı ID bulunamadı'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(company?.compUserId.toString() ?? 'Kullanıcı ID bulunamadı'),
          Text(company?.compName.toString() ?? 'Kullanıcı ID bulunamadı'),
        ],
      ),
    );
  }
}
