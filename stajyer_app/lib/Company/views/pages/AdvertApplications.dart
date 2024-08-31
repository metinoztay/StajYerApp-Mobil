import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stajyer_app/Company/models/AppUserModel.dart';
import 'package:stajyer_app/Company/services/api/ApplicationService.dart';
import 'package:stajyer_app/User/services/api/CityService.dart';
import 'package:stajyer_app/User/services/api/UnivercityService.dart';
import 'package:stajyer_app/User/utils/colors.dart';

class AdvertApplications extends StatefulWidget {
  final int advertId; //zorunlu bir advert id
  AdvertApplications({required this.advertId});

  @override
  _AdvertApplicationsState createState() => _AdvertApplicationsState();
}

class _AdvertApplicationsState extends State<AdvertApplications> {
  List<Map<String, dynamic>> universities = [];

  Future<void> _fetchData() async {
    try {
      final univercityService = UnivercityService();
      universities = await univercityService.getUniversities();
      // programs = await univercityService.getPrograms();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veriler alınırken bir hata oluştu: $e')),
      );
      print('Veri alma hatası: $e'); // Hata mesajını loglayın
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Başvuranlar')),
      body: FutureBuilder<List<AppUserModel>>(
        future: ApplicationService().fetchApplicants(widget.advertId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Başvuran bulunamadı'),
            );
          } else {
            final applicants = snapshot.data!;
            return ListView.builder(
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                final user = applicants[index];

                print(
                    'Eğitimler: ${user.educations.map((e) => e.toJson()).toList()}');
                return _ApplicantCard(user: user);
              },
            );
          }
        },
      ),
    );
  }
}

class _ApplicantCard extends StatefulWidget {
  final AppUserModel user;
  _ApplicantCard({required this.user});

  @override
  __ApplicantCardState createState() => __ApplicantCardState();
}

class __ApplicantCardState extends State<_ApplicantCard> {
  bool _isExpanded = false;
  late UnivercityService _educationService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _educationService = UnivercityService();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      color: ilanCard,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ExpansionTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 240, 240, 240),
          ),
          child: ClipOval(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.network(
                widget.user.uprofilephoto ?? 'https://via.placeholder.com/150',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
        title: Text(
          '${widget.user.uname} ${widget.user.usurname}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.user.uemail ?? "",
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_more : Icons.expand_less,
          color: Colors.white,
        ),
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.white),
          ),
          _buildApplicant(),
          ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text(
              " ${widget.user.udesc == "Kendinizi tanıtınız" || widget.user.udesc == null ? "Hakkımda yazısı eklenmemiş" : widget.user.udesc}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.white),
            title: Text(
              ' ${widget.user.uemail ?? "Mail bilgisi bulunmamaktadır."}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.white),
            title: Text(
              ' ${widget.user.uphone == "Şirketlerin size ulaşabilmesi için telefon numarası girmelisiniz." || widget.user.uphone == null ? "Telefon numarası eklenmemiş" : widget.user.uphone}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.cake, color: Colors.white),
            title: Text(
              ' ${widget.user.ubirthdate ?? "Doğum tarihi bilgisi bulunmamaktadır."}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.transgender, color: Colors.white),
            title: Text(
              "${widget.user.ugender ? "Erkek" : "Kadın"}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.code, color: Colors.white),
            title: Text(
              " ${widget.user.ugithub == "Github adresinizi giriniz" || widget.user.ugithub == null ? "Github adresi eklenmemiş" : widget.user.ugithub}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.business_center, color: Colors.white),
            title: Text(
              " ${widget.user.ulinkedin == "Linkedin adresinizi giriniz" || widget.user.ulinkedin == null ? "Linkedin adresi eklenmemiş" : widget.user.ulinkedin}",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
              leading: Icon(Icons.description, color: Colors.white),
              title: Text(
                " Cv :${widget.user.ucv == "Cv linkinizi giriniz" || widget.user.ucv == null ? "Cv Linki eklenmemiş" : widget.user.ucv}",
                style: TextStyle(color: Colors.white),
              )),
          _buildCertificatesSection(),
          _buildProjectsSection(),
          _buildExperienceSection(),
          _buildEducationSection(),
        ],
      ),
    );
  }

  Widget _buildApplicant() {
    return ListTile(
      title: Text(
        "Başvuru Detayı",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      subtitle: widget.user.applications.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.user.applications.map((applicant) {
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Başvuru Tarihi: ${applicant.appDate}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "Başvuru Mektubu:",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          applicant.appLetter,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Başvuru bulunmamaktadır.",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
    );
  }

  Widget _buildCertificatesSection() {
    return ExpansionTile(
      title: Text(
        'Sertifikalar',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: widget.user.certificates.isNotEmpty
                ? widget.user.certificates.map((certificate) {
                    return Card(
                      color: Colors.teal[50],
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.verified, color: Colors.teal),
                                SizedBox(width: 8),
                                Text(
                                  certificate.certName ?? "Sertifika Adı",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.business, color: Colors.teal),
                                SizedBox(width: 8),
                                Text(
                                  certificate.cerCompanyName ?? "Şirket Adı",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.date_range, color: Colors.teal),
                                SizedBox(width: 8),
                                Text(
                                  certificate.certDate ?? "Tarih",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.description, color: Colors.teal),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    certificate.certDesc ??
                                        "Açıklama eklenmemiş.",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList()
                : [
                    ListTile(
                      title: Text(
                        'Sertifika bulunmamaktadır.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectsSection() {
    return ExpansionTile(
      title: Text(
        'Projeler',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      children: widget.user.projects.isNotEmpty
          ? widget.user.projects.map((project) {
              return Card(
                color: Colors.teal[50],
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.nest_cam_wired_stand_sharp,
                              color: Colors.teal),
                          SizedBox(width: 8),
                          Text(
                            project.proName ?? "Proje Adı",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.business, color: Colors.teal),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              project.proDesc ?? "Proje Açıklaması",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.date_range, color: Colors.teal),
                          SizedBox(width: 8),
                          Text(
                            project.proGithub ?? "Github linki",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList()
          : [
              ListTile(
                title: Text('Projeleri bulunmamaktadır.',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
    );
  }

  Widget _buildExperienceSection() {
    return ExpansionTile(
      title: Text(
        'Deneyimler',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      children: widget.user.experiences.isNotEmpty
          ? widget.user.experiences.map((experience) {
              return Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.work, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            experience.expPosition ?? "Pozisyon",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.business, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            experience.expCompanyName ?? "Şirket Adı",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      FutureBuilder<String>(
                        future: CityService()
                            .getCityById(experience.expCityId ?? 0),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Row(
                              children: [
                                Icon(Icons.location_city, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  "Şehir yükleniyor...",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Row(
                              children: [
                                Icon(Icons.location_city, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  "Şehir yüklenemedi",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Icon(Icons.location_city, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  snapshot.data ?? "Şehir",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.date_range, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            '${experience.expStartDate ?? "Başlangıç Tarihi"} - ${experience.expFinishDate ?? "Bitiş Tarihi"}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.description, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              experience.expDesc ?? "Açıklama eklenmemiş.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList()
          : [
              ListTile(
                title: Text('Deneyim bulunmamaktadır.',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
    );
  }

  Widget _buildEducationSection() {
    return ExpansionTile(
      title: Text(
        'Eğitim',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      children: widget.user.educations.isNotEmpty
          ? widget.user.educations.map((education) {
              return FutureBuilder<Map<String, dynamic>>(
                future: Future.wait([
                  _educationService.getUniversityName(education.uniId),
                  _educationService.getProgramById(education.progId),
                ]).then((results) {
                  return {
                    'universityName': results[0],
                    'program': results[1],
                  };
                }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return ListTile(title: Text('Hata: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return ListTile(title: Text('Bilgi bulunamadı.'));
                  }

                  final universityName = snapshot.data!['universityName'];
                  final program = snapshot.data!['program'];

                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.school, color: ilanCard),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  universityName ?? 'Üniversite Adı Bulunmuyor',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.book, color: ilanCard),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  program['progName'] ??
                                      'Program Adı Bulunmuyor',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.date_range, color: ilanCard),
                              SizedBox(width: 8),
                              Text(
                                '${education.eduStartDate ?? "Başlangıç Tarihi"} - ${education.eduFinishDate ?? "Bitiş Tarihi"}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.grade, color: ilanCard),
                              SizedBox(width: 8),
                              Text(
                                education.eduGano != null
                                    ? 'GANO: ${education.eduGano}'
                                    : "GANO: Bilinmiyor",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.info, color: ilanCard),
                              SizedBox(width: 8),
                              Text(
                                education.eduSituation ?? "Durum Bilgisi",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.description, color: ilanCard),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  education.eduDesc ?? "Açıklama eklenmemiş.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList()
          : [
              ListTile(
                title: Text('Eğitim bilgisi bulunmamaktadır.'),
              ),
            ],
    );
  }
}
