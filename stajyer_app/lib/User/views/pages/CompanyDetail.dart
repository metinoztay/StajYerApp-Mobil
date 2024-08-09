import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stajyer_app/User/models/CompanyAdvModel.dart';
import 'package:stajyer_app/User/models/CompanyModel.dart';
import 'package:stajyer_app/User/models/homeAdvModel.dart';
import 'package:stajyer_app/User/services/api/CompanyDetailService.dart';
import 'package:stajyer_app/User/services/api/homeAdvService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/advDetail.dart';

class CompanyDetail extends StatefulWidget {
  final CompanyModel company;
  const CompanyDetail({required this.company});

  @override
  State<CompanyDetail> createState() => _CompanyDetailState();
}

class _CompanyDetailState extends State<CompanyDetail> {
  List<CompanyAdvModel> _activeAdverts = [];
  List<CompanyAdvModel> _allAdverts = [];
  bool _isLoading = true;
  HomeAdvModel convertToHomeAdvModel(CompanyAdvModel companyAdvModel) {
    return HomeAdvModel(
      advWorkType: companyAdvModel.advWorkType,
      advTitle: companyAdvModel.advTitle,
      advJobDesc: companyAdvModel.advJobDesc,
      advAdress: companyAdvModel.advAdress,
      advIsActive: companyAdvModel.advIsActive,
      advPhoto: companyAdvModel.advPhoto,
      advAdressTitle: companyAdvModel.advAdressTitle,
      advQualifications: companyAdvModel.advQualifications,
      advAddInformation: companyAdvModel.advAddInformation,
      advExpirationDate: companyAdvModel.advExpirationDate,
      advPaymentInfo: companyAdvModel.advPaymentInfo,
      advDepartment: companyAdvModel.advDepartment,
      advertId: companyAdvModel.advertId,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAdverts();
  }

  Future<void> _fetchAdverts() async {
    try {
      final adverts = await Companydetailservice()
          .getAdvertsByCompanyId(widget.company.compId!);
      setState(() {
        _allAdverts = adverts;
        _activeAdverts =
            adverts.where((adv) => adv.advIsActive == true).toList();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Şirket Detayı"),
      ),
      body: DefaultTabController(
        length: 3, //Tabs sayısı
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: "Hakkımızda"),
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
                  // Hakkımızda
                  _buildAboutTab(),
                  // Aktif İlanlar
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _buildAdvertsList(_activeAdverts),
                  // Tüm İlanlar
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _buildAdvertsList(_allAdverts),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: companyCard1,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.network(
                        widget.company.compLogo ??
                            'https://via.placeholder.com/150',
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    widget.company.compName.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              widget.company.compDesc.toString(),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            buildDetailRow(Icons.work, widget.company.compSektor.toString()),
            SizedBox(height: 20),
            buildDetailRow(
                Icons.person_2, widget.company.compEmployeeCount.toString()),
            SizedBox(height: 20),
            buildDetailRow(
                FontAwesomeIcons.globe, widget.company.compWebSite.toString()),
            SizedBox(height: 20),
            buildDetailRow(FontAwesomeIcons.locationDot,
                widget.company.compAdress.toString()),
            SizedBox(height: 20),
            buildDetailRow(
                Icons.email, widget.company.compContactMail.toString()),
            SizedBox(height: 20),
            buildDetailRow(
                Icons.date_range, widget.company.compFoundationYear.toString()),
            SizedBox(height: 20),
            buildDetailRow(
                Icons.link_sharp, widget.company.comLinkedin.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvertsList(List<CompanyAdvModel> adverts) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: adverts.map((advert) {
          return buildJobCard(
            sirketAdi: widget.company.compName ?? "No Company Name",
            logo: widget.company.compLogo ?? 'https://via.placeholder.com/150',
            worktype: advert.advWorkType ?? "No Work Type",
            title: advert.advTitle ?? "No Title",
            description: advert.advJobDesc ?? "No Description",
            location: advert.advAdress ?? "No Location",
            isActive: advert.advIsActive ?? false,
            advert: convertToHomeAdvModel(advert),
          );
        }).toList(),
      ),
    );
  }

  Widget buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 10),
        Expanded(
          child: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget buildJobCard({
    required String logo,
    required String title,
    required String description,
    required String location,
    required bool isActive,
    required String worktype,
    required String sirketAdi,
    required HomeAdvModel advert,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          SizedBox(
            width: 380,
            height: 250,
            child: Card(
              color:
                  isActive ? companyCard1 : Colors.grey[300], // Arka plan rengi
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
                        FaIcon(
                          FontAwesomeIcons.map,
                          color: isActive ? Colors.white : Colors.black,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdvCardDetail(advert: advert),  
                            ),
                          );
                        },
                        child: Text(
                          "Detaylı Bilgi",
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isActive ? companyCard2 : Colors.grey,
                        ),
                      ),
                    ),
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
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.network(
                            logo ?? 'https://via.placeholder.com/150',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sirketAdi,
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