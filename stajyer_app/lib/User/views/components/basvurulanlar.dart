import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/User/models/homeAdvModel.dart';
import 'package:stajyer_app/User/services/api/userApplyService.dart';
import 'package:stajyer_app/User/views/components/advCard.dart';

class AppliedAdvertsPage extends StatefulWidget {
  @override
  _AppliedAdvertsPageState createState() => _AppliedAdvertsPageState();
}

class _AppliedAdvertsPageState extends State<AppliedAdvertsPage> {
  late Future<List<HomeAdvModel>> _appliedAdverts;

  @override
  void initState() {
    super.initState();
    _appliedAdverts = _fetchAppliedAdverts();
  }

  Future<int?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<List<HomeAdvModel>> _fetchAppliedAdverts() async {
    int? userId = await _getUserId();
    if (userId != null) {
      Userapplyservice service = Userapplyservice();
      return service.fetchApplyAdvertsByUserId(userId);
    } else {
      throw Exception('Kullanıcı ID bulunamadı');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: FutureBuilder<List<HomeAdvModel>>(
        future: _appliedAdverts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Başvurulan ilan bulunamadı.'));
          } else {
            List<HomeAdvModel> applyAdvertslist = snapshot.data!;
            return ListView.builder(
              itemCount: applyAdvertslist.length,
              itemBuilder: (context, index) {
                final advert = applyAdvertslist[index];
                return AdvCard(advert: advert);
              },
            );
          }
        },
      ),
    );
  }
}
