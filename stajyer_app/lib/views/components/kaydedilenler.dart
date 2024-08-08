import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/models/homeAdvModel.dart';
import 'package:stajyer_app/services/api/savedListService.dart';
import 'package:stajyer_app/views/components/advCard.dart';

class SavedListPage extends StatefulWidget {
  @override
  _SavedListPageState createState() => _SavedListPageState();
}

class _SavedListPageState extends State<SavedListPage> {
  late Future<List<HomeAdvModel>> _savedAdvertsFuture;
  final SavedlistService _savedlistService = SavedlistService();
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
      if (userId != null) {
        _savedAdvertsFuture = _savedlistService.fetchSavedAdvertsByUserId(userId!);
      } else {
        // Handle user ID not found case
        _savedAdvertsFuture = Future.error('Kullanıcı ID bulunamadı');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: userId == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder<List<HomeAdvModel>>(
              future: _savedAdvertsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState  == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Kayıtlı ilan yok'));
                }

                final savedAdverts = snapshot.data!;

                return ListView.builder(
                  itemCount: savedAdverts.length,
                  itemBuilder: (context, index) {
                    final advert = savedAdverts[index];
                    return AdvCard(advert:advert);
                  },
                );
              },
            ),
    );
  }

}