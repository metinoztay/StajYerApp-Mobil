import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stajyer_app/User/models/homeAdvModel.dart';
import 'package:stajyer_app/User/services/api/homeAdvService.dart';
import 'package:stajyer_app/User/utils/colors.dart';
import 'package:stajyer_app/User/views/components/advDetail.dart';
import 'package:stajyer_app/User/views/components/saveButton.dart';

class AdvCardBuilder extends StatefulWidget {
  const AdvCardBuilder({super.key});

  @override
  State<AdvCardBuilder> createState() => _AdvCardBuilderState();
}

class _AdvCardBuilderState extends State<AdvCardBuilder> {
  Future<List<HomeAdvModel>?>? _advList;

  @override
  void initState() {
    super.initState();
    _advList = AdvertService().fetchAdverts(); // Başlatma işlemi
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<HomeAdvModel>?>(
        future: _advList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(child: Text('İlan Bulunmamaktadır!'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return AdvCard(advert: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}

class AdvCard extends StatefulWidget {
  final HomeAdvModel advert;

  const AdvCard({required this.advert, super.key});

  @override
  State<AdvCard> createState() => _AdvCardState();
}

class _AdvCardState extends State<AdvCard> {
  bool kayitlimi = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 240,
            child: Card(
              color: ilanCard,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        getShortDescription(widget.advert.advJobDesc, 19) ??
                            'İlan açıklaması yoook',
                        style: TextStyle(color: Colors.white),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.map,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.advert.advAdressTitle ?? 'Konum yok',
                                    style: TextStyle(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AdvCardDetail(advert: widget.advert),
                                ),
                              );
                            },
                            child: Text("Detaylı Bilgi"),
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(120, 36), // Buton boyutu
                                foregroundColor: ilanCard,
                                backgroundColor: background),
                          ),
                          SaveButton(
                            advertId: widget.advert.advertId != null
                                ? widget.advert.advertId!.toInt()
                                : 0,
                            ColorSave: ColorsaveWhite,
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
            width: double.infinity,
            height: 80,
            child: Card(
              color: ilanCard1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
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
                            widget.advert.comp?.compLogo ??
                                'https://via.placeholder.com/150',
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
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getShortDescription(
                                widget.advert.comp?.compName, 4),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            widget.advert.advTitle ?? 'İlan Başlığı Yok',
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
        ],
      ),
    );
  }
}

String getShortDescription(String? description, int maxWords) {
  if (description == null || description.isEmpty) {
    return 'İlan açıklaması yokkk';
  }
  List<String> words = description.split(' ');
  if (words.length <= maxWords) {
    return description;
  }
  return words.sublist(0, maxWords).join(' ') + '...';
}
