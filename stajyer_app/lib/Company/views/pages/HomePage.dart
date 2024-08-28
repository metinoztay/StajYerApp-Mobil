import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stajyer_app/Company/models/Advertisement.dart';
import 'package:stajyer_app/Company/services/api/CompanyAdvertService.dart';
import 'package:stajyer_app/Company/views/pages/AdvertApplications.dart';
import 'package:stajyer_app/Company/views/pages/EditAdvertPage.dart';
import 'package:stajyer_app/Company/views/pages/deneme.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/SirketCard.dart';

class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({super.key});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  List<Advertisement> _activeAdverts = [];
  List<Advertisement> _allAdverts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdverts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Bu sayfaya döndüğümüzde güncellemeleri kontrol et
    final bool? shouldRefresh =
        ModalRoute.of(context)?.settings.arguments as bool?;
    if (shouldRefresh == true) {
      _fetchAdverts();
    }
  }

  Future<void> _fetchAdverts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? companyUserId = prefs.getInt('compUserId');

      if (companyUserId != null) {
        final adverts = await CompanyAdvertService()
            .fetchAdvertisementsByCompanyUserId(companyUserId);

        setState(() {
          _allAdverts = adverts;
          _activeAdverts = adverts.where((adv) => adv.advIsActive).toList();
          _isLoading = false;
        });
      } else {
        print("Company User ID not found");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching adverts: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAdvert(int? advId) async {
    if (advId != null) {
      try {
        await CompanyAdvertService().deleteAdvert(advId);
        setState(() {
          // İlanı aktif ilanlardan çıkar
          _activeAdverts.removeWhere((adv) => adv.advertId == advId);

          // İlanı tüm ilanlar listesine taşımak yerine silmek istiyorsanız,
          // aşağıdaki satırı kullanarak tüm ilanlardan da çıkarabilirsiniz.
          // _allAdverts.removeWhere((adv) => adv.advertId == advId);
        });
      } catch (error) {
        print("İlan silinirken hata: $error");
      }
    } else {
      print("İlan ID bulunamadı");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String companyLogo = 'https://via.placeholder.com/150';
    final String companyName = 'Company Name';

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: "Aktif İlanlar"),
                Tab(text: "Tüm İlanlar"),
              ],
              indicatorColor: appbar,
              labelColor: appbar,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
                child: TabBarView(
              children: [
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _buildAdvertsList(
                        _activeAdverts, companyLogo, companyName),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _buildAdvertsList(_allAdverts, companyLogo, companyName),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildAdvertsList(
      List<Advertisement> adverts, String logo, String companyName) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: adverts.isNotEmpty
            ? Column(
                children: adverts.map((advert) {
                  return buildJobCard(
                      worktype: advert.advWorkType ?? "No Work Type",
                      title: advert.advTitle ?? "No Title",
                      description: advert.advJobDesc ?? "No Description",
                      location: advert.advAdressTitle ?? "No Location",
                      isActive: advert.advIsActive ?? false,
                      count: advert.advAppCount ?? "",
                      advert: advert);
                }).toList(),
              )
            : Center(
                child: Text(" İlanınız bulunmamaktadır"),
              ));
  }

  Widget buildJobCard({
    required String title,
    required String description,
    required String location,
    required bool isActive,
    required String worktype,
    String? count,
    required Advertisement advert,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity, // Use double.infinity for width
            height: 250,
            child: Card(
              color: isActive ? companyCard1 : Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 90.0, right: 20.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            description,
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.black,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        FaIcon(
                          FontAwesomeIcons.peopleGroup,
                          color: isActive ? Colors.white : Colors.black,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            count.toString() + " kişi",
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdvertApplications(
                                        advertId: advert.advertId)),
                              );
                              // Başvuruları Görüntüle butonuna basıldığında yapılacak işlemler
                            },
                            child: Text(
                              "Başvuruları Görüntüle",
                              style: TextStyle(
                                color: isActive ? companyCard1 : Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isActive ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditAdvertPage(advert: advert),
                                ),
                              ).then((result) {
                                // Geri dönerken güncellemeleri kontrol et
                                if (result == true) {
                                  _fetchAdverts(); // Güncellenmiş ilanları yeniden yükle
                                }
                              });
                            },
                            child: Text(
                              "İlan Düzenle",
                              style: TextStyle(
                                color: isActive ? companyCard1 : Colors.black,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isActive ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Card(
              color: isActive ? companyCard2 : Colors.grey[400],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            location,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _deleteAdvert(advert.advertId);
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
