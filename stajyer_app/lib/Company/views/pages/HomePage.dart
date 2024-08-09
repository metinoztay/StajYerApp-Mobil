import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stajyer_app/Company/models/Advertisement.dart';
import 'package:stajyer_app/Company/services/api/CompanyAdvertService.dart';
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

  Future<void> _fetchAdverts() async {
    try {
      final adverts =
          await CompanyAdvertService().fetchAdvertisementsByCompanyUserId(1);

      setState(() {
        _allAdverts = adverts;
        _activeAdverts = adverts.where((adv) => adv.advIsActive).toList();
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching adverts: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Assuming company logo and name are passed in or defined somewhere
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
      child: Column(
        children: adverts.map((advert) {
          return buildJobCard(
            worktype: advert.advWorkType ?? "No Work Type",
            title: advert.advTitle ?? "No Title",
            description: advert.advJobDesc ?? "No Description",
            location: advert.advAdress ?? "No Location",
            isActive: advert.advIsActive ?? false,
            count: advert.advAppCount ?? "",
          );
        }).toList(),
      ),
    );
  }

  Widget buildJobCard({
    required String title,
    required String description,
    required String location,
    required bool isActive,
    required String worktype,
    String? count,
  }) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        children: [
          SizedBox(
            width: 380,
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
                            count.toString() + " kişi",
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
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         AdvCardDetail(advert: advert),
                              //   ),
                              // );
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
                        SizedBox(width: 8), // Daha uygun bir boşluk değeri
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         AdvCardDetail(advert: advert),
                              //   ),
                              // );
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
            width: 380,
            height: 80,
            child: Card(
              color: isActive ? companyCard2 : Colors.grey[400],
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    // Container(
                    //   width: 40,
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Colors.white,
                    //   ),
                    //   child: ClipOval(
                    //     child: FittedBox(
                    //       fit: BoxFit.cover,
                    //       child: Image.network(
                    //         logo,
                    //         width: 40,
                    //         height: 40,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          title,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
