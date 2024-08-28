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
  Future<bool>? companyStatusFuture;
  // companyStatusFuture, şirket eklenip eklenmediğini kontrol eden bir Future<bool> nesnesidir.
  // Bu Future, sayfanın durumu yüklendiğinde başlatılır ve tamamlandığında şirketin eklenip eklenmediğini belirtir.

  @override
  void initState() {
    super.initState();
    companyStatusFuture = _checkCompanyStatus();
    // initState'de companyStatusFuture değişkenine _checkCompanyStatus() fonksiyonunu atıyoruz.
    // Bu fonksiyon şirketin var olup olmadığını kontrol eder ve sonucunu bir Future<bool> olarak döner.
  }

  Future<bool> _checkCompanyStatus() async {
    // Bu fonksiyon, SharedPreferences'tan kullanıcı ID'sini alır ve bu ID'ye göre şirket bilgilerini kontrol eder.

    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? compuserId = prefs.getInt('compUserId');

    if (compuserId != null) {
      try {
        CompanyInfoService compService = CompanyInfoService();

        Company? fetchedCompany =
            await compService.getCompanyInfoByCompUserId(compuserId);

        return fetchedCompany != null;
      } catch (e) {
        print("Şirket bilgileri alınamadı");
        return false;
      }
    } else {
      print("Kullanıcı ID bulunamadı");

      return false;
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('compUserId');
    // Kullanıcı ID'sini yerel depolamadan siler, böylece kullanıcı çıkış yapmış olur.

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CompanyLoginPage()));
  }

  Future<void> _showAddCompanyDialog() async {
    bool companyAdded = await showAddCompanyDialog(context);

    if (companyAdded) {
      setState(() {
        companyStatusFuture = _checkCompanyStatus();
      });
      // companyStatusFuture'u günceller ve şirket eklenip eklenmediğini yeniden kontrol eder.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: companyStatusFuture,
        // FutureBuilder, companyStatusFuture Future'ını bekler.

        builder: (context, snapshot) {
          // Future'ın tamamlandığı an builder metodu tetiklenir.

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
            // Eğer Future hala tamamlanmadıysa, bir yükleme göstergesi gösterilir.
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu.'));
            // Eğer Future bir hata döndürdüyse, bir hata mesajı gösterilir.
          } else {
            bool isCompanyAdded = snapshot.data ?? false;
            // Future tamamlandığında dönen veriyi alır. Eğer veri yoksa, false olarak kabul edilir.

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    if (!isCompanyAdded)
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
                            Icon(Icons.info_outline,
                                color: Colors.teal, size: 24),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'İlan Ekleme ve Şirket Bilgilerini düzenleme yapabilmeniz için şirket eklemeniz gerekmektedir.',
                                style: TextStyle(
                                    color: Colors.teal[800], fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 110),
                    ElevatedButton(
                      onPressed: isCompanyAdded
                          ? null
                          : () async {
                              await _showAddCompanyDialog();
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _logout,
                      child: Text(
                        'Çıkış Yap',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
