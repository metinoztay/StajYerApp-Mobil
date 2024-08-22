import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stajyer_app/User/models/CompanyModel.dart';
import 'package:stajyer_app/User/services/api/CompanyService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/pages/CompanyDetail.dart';

class SirketCard extends StatefulWidget {
  final String searchText;

  const SirketCard({super.key, required this.searchText});

  @override
  State<SirketCard> createState() => _SirketCardState();
}

class _SirketCardState extends State<SirketCard> {
  Future<List<CompanyModel>?>? _companyList;

  @override
  void initState() {
    super.initState();
    _companyList = CompanyService().getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CompanyModel>?>(
      future: _companyList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          // Filtreleme işlemi
          var filteredList = snapshot.data!
              .where((company) =>
                  company.compName!.toLowerCase().contains(widget.searchText))
              .toList();

          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (BuildContext context, int index) {
              return CompanyCard(company: filteredList[index]);
            },
          );
        }
      },
    );
  }
}

class CompanyCard extends StatelessWidget {
  final CompanyModel company;

  const CompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ;
        // CompanyService companyService = CompanyService();
        // CompanyModel? companyDetail = await companyService.getFoodById(food.id!);
        // if (foodDetail != null) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => RecipesDetail(food: foodDetail),
        //     ),
        //   );
        // } else {
        //   // Hata durumunu ele alabilirsiniz
        //   print('Failed to fetch food details.');
        // }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(children: [
          SizedBox(
            width: 380,
            height: 200,
            child: Card(
              color: companyCard1,
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_3_rounded, color: Colors.white),
                          Text(
                            company.compEmployeeCount.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.businessTime,
                              color: Colors.white),
                          Text(
                            company.compFoundationYear.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.map,
                            color: Colors.white,
                          ),
                          Text(
                            company.compAddressTitle.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
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
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Container(
                    width: 40, // Avatar size
                    height: 40, // Avatar size
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          Colors.white, // Background color for missing images
                    ),
                    child: ClipOval(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.network(
                          company.compLogo ?? 'https://via.placeholder.com/150',
                          width: 40, // Avatar size
                          height: 40, // Avatar size
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                                'https://via.placeholder.com/150'); // Fallback image
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      company.compName ?? 'Company Name',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () async {
                      CompanyService companyService = CompanyService();
                      CompanyModel? companyDetail =
                          await companyService.getCompanyById(company.compId!);
                      if (CompanyDetail != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CompanyDetail(company: companyDetail),
                          ),
                        );
                      } else {
                        // Hata durumunu ele alabilirsiniz
                        print('Failed to fetch food details.');
                      }
                    },
                  ),
                ],
              ),
              color: companyCard2,
            ),
          ),
        ]),
      ),
    );
  }
}
