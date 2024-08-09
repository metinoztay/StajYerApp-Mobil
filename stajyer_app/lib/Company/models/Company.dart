import 'package:stajyer_app/Company/models/Advertisement.dart';

class Company {
  final int compId;
  final String? compName;
  final String? compFoundationYear;
  final String? compWebSite;
  final String? compContactMail;
  final String? compAdress;
  final String? compAddressTitle;
  final String? compSektor;
  final String? compDesc;
  final String? compLogo;
  final String? comLinkedin;
  final int? compEmployeeCount;
  final int compUserId;
  final List<Advertisement>? advertisements;

  Company({
    required this.compId,
    this.compName,
    this.compFoundationYear,
    this.compWebSite,
    this.compContactMail,
    this.compAdress,
    this.compAddressTitle,
    this.compSektor,
    this.compDesc,
    this.compLogo,
    this.comLinkedin,
    this.compEmployeeCount,
    required this.compUserId,
    this.advertisements,
  });
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      compId: json['compId'],
      compName: json['compName'],
      compFoundationYear: json['compFoundationYear'],
      compWebSite: json['compWebSite'],
      compContactMail: json['compContactMail'],
      compAdress: json['compAdress'],
      compAddressTitle: json['compAddressTitle'],
      compSektor: json['compSektor'],
      compDesc: json['compDesc'],
      compLogo: json['compLogo'],
      comLinkedin: json['comLinkedin'],
      compEmployeeCount: json['compEmployeeCount'],
      compUserId: json['compUserId'],
      advertisements: (json['advertisements'] as List<dynamic>?)
          ?.map((ad) => Advertisement.fromJson(ad))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compId': compId,
      'compName': compName,
      'compFoundationYear': compFoundationYear,
      'compWebSite': compWebSite,
      'compContactMail': compContactMail,
      'compAdress': compAdress,
      'compAddressTitle': compAddressTitle,
      'compSektor': compSektor,
      'compDesc': compDesc,
      'compLogo': compLogo,
      'comLinkedin': comLinkedin,
      'compEmployeeCount': compEmployeeCount,
      'compUserId': compUserId,
      'advertisements': advertisements?.map((ad) => ad.toJson()).toList(),
    };
  }
}
