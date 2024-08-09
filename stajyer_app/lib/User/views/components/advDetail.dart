import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stajyer_app/User/models/homeAdvModel.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/basvur.dart';
import 'package:stajyer_app/User/views/components/saveButton.dart';

class AdvCardDetail extends StatelessWidget {
  final HomeAdvModel advert;

  const AdvCardDetail({required this.advert, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // AppBar yüksekliğini ayarlayın
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1), // sadece alt tarafına gölge
              ),
            ],
          ),
          child: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25,
              ),
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            title: Row(
              children: [
                Container(
                  width: 40, // Avatar boyutu
                  height: 40, // Avatar boyutu
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Boş alanlar için beyaz arka plan
                  ),
                  child: ClipOval(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.network(
                        advert.comp?.compLogo ??
                            'https://via.placeholder.com/150',
                        width: 40, // Avatar boyutu
                        height: 40, // Avatar boyutu
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getShortDescription(advert.comp?.compName, 4),
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20),
                      ),
                      Text(
                        advert.advTitle ?? 'İlan Başlığı Yok',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              SaveButton(
                advertId: advert.advertId!.toInt(),
                ColorSave: ColorsaveBlack,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: ilanCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(advert.advPhoto.toString()),
                          sectionTitle('Açıklamaaa'),
                          Text(
                            advert.advJobDesc ?? 'Açıklama yok',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(height: 10),
                          sectionTitle('Gereklilikler'),
                          Text(
                            advert.advQualifications ?? 'İlan açıklaması yok',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(height: 10),
                          sectionTitle('Informations'),
                          Text(
                            advert.advAddInformation ?? 'İlan açıklaması yok',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(height: 20),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.map,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      advert.advAdressTitle ?? 'Konum yok',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.briefcase,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      advert.advWorkType ??
                                          'çalışma tipi yok(hybrid, yüzyüze)',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.calendarCheck,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      advert.advExpirationDate ??
                                          "son başvuru tarihi yok",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    FaIcon(
                                      advert.advPaymentInfo == true
                                          ? FontAwesomeIcons.dollarSign
                                          : FontAwesomeIcons.dollarSign,
                                      color: Colors.white,
                                    ), // Ödeme bilgisi için
                                    SizedBox(width: 10),
                                    Text(
                                      advert.advPaymentInfo == true
                                          ? 'Ödeme mevcut'
                                          : 'Ödeme yok',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                    SizedBox(
                                      width: 100,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: ElevatedButton(
                              //     onPressed: () {
                              //       // Başvuru butonuna tıklama işlemi
                              //     },
                              //     child: Text("Başvur"),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: double.infinity,
                //   height: 100,
                //   child: Card(
                //     color: ilanCard1,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(10.0),
                //       child: Row(
                //         children: [
                //           IconButton(
                //             onPressed: () {
                //               Navigator.pop(context);
                //             },
                //             icon: Icon(Icons.arrow_back_ios),
                //             color: Colors.white,
                //           ),
                //           Container(
                //             width: 40, // Avatar boyutu
                //             height: 40, // Avatar boyutu
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: Colors
                //                   .white, // Boş alanlar için beyaz arka plan
                //             ),
                //             child: ClipOval(
                //               child: FittedBox(
                //                 fit: BoxFit.cover,
                //                 child: Image.network(
                //                   advert.comp?.compLogo ??
                //                       'https://via.placeholder.com/150',
                //                   width: 40, // Avatar boyutu
                //                   height: 40, // Avatar boyutu
                //                 ),
                //               ),
                //             ),
                //           ),
                //           SizedBox(width: 10),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Text(
                //                 getShortDescription(advert.comp?.compName,
                //                     4), // 'Şirket Adı Yok' varsayılan değeri getShortDescription içinde ele alındığı için burada ihtiyaç yok
                //                 style: TextStyle(color: Colors.white),
                //               ),
                //               Text(
                //                 advert.advTitle ?? 'İlan Başlığı Yok',
                //                 style: TextStyle(
                //                     color: Colors.white, fontSize: 16),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: detailpagenavbar(
        advert: advert,
      ),
    );
  }

  Padding sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          color: button,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

String getShortDescription(String? description, int maxWords) {
  if (description == null || description.isEmpty) {
    return 'İlan açıklaması yok';
  }
  List<String> words = description.split(' ');
  if (words.length <= maxWords) {
    return description;
  }
  return words.sublist(0, maxWords).join(' ') + '...';
}

class detailpagenavbar extends StatelessWidget {
  final HomeAdvModel advert;

  const detailpagenavbar({required this.advert, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int advertId;
    if (advert.advertId != null) {
      advertId = advert.advertId!.toInt();
    } else {
      advertId = 0;
    }

    return Visibility(
      visible: advert.advIsActive ?? false,
      child: SizedBox(
        height: 90,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30.0, top: 20),
          child: ApplicationButton(advertId: advertId),
        ),
      ),
    );
  }
}
