import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/Company.dart';
import 'package:stajyer_app/Company/services/api/CompanyInfoService.dart';
import 'package:stajyer_app/Company/views/components/showAddCompanyDialog.dart';
import 'package:stajyer_app/Company/views/pages/EditCompanyPage.dart';
import 'package:stajyer_app/Company/views/pages/loginPage.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  Company? company;
  bool isLoading = true;
  bool isCompanyAdded =
      false; // Şirket eklenip eklenmediğini takip etmek için değişken

  @override
  void initState() {
    super.initState();
    _checkCompanyStatus(); // Şirket eklenip eklenmediğini kontrol et
  }

  Future<void> _checkCompanyStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? compuserId = prefs.getInt('compUserId');

    if (compuserId != null) {
      try {
        CompanyInfoService compService = CompanyInfoService();
        Company? fetchedCompany =
            await compService.getCompanyInfoByCompUserId(compuserId);
        setState(() {
          company = fetchedCompany;
          isCompanyAdded = company != null;
          isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Şirket bilgileri alınamadı'),
          ),
        );
        setState(() {
          isLoading = false;
        });
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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('compUserId');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CompanyLoginPage()));
  }

  Future<void> _showAddCompanyDialog() async {
    bool companyAdded = await showAddCompanyDialog(context);
    if (companyAdded) {
      setState(() {
        isCompanyAdded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            if (!isCompanyAdded) // Yalnızca şirket eklenmemişse göster
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.teal, size: 24),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'İlan Ekleme ve Şirket Bilgilerini düzenleme yapabilmeniz için şirket eklemeniz gerekmektedir.',
                        style: TextStyle(color: Colors.teal[800], fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 110),
            ElevatedButton(
              onPressed: isCompanyAdded
                  ? null // Disable button if company is added
                  : () async {
                      await _showAddCompanyDialog(); // await with dialog
                    },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: ilanCard,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Şirket Ekle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: isCompanyAdded
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCompanyPage()));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: ilanCard,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Şirket Bilgilerini Düzenle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 40),
                backgroundColor: Colors.white,
                foregroundColor: ilanCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: _logout,
              child: Text("Çıkış Yap"),
            ),
          ],
        ),
      ),
    );
  }
}
