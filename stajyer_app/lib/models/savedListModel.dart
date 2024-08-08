// // import 'package:stajyer_app/models/Savedlistmodel.dart';

// // class Savedlistmodel {
// //   final int compId;
// //   final int advertId;
// //   final String advTitle;
// //   final String advAdressTitle;
// //   final String advAdress;
// //   final String advWorkType;
// //   final String advDepartment;
// //   final String advJobDesc;
// //   final String advQualifications;
// //   final String advAddInformation;
// //   final DateTime advExpirationDate;
// //   final String advPhoto;
// //   final bool advPaymentInfo;

// //   Savedlistmodel({
// //     required this.compId,
// //     required this.advertId,
// //     required this.advTitle,
// //     required this.advAdressTitle,
// //     required this.advAdress,
// //     required this.advWorkType,
// //     required this.advDepartment,
// //     required this.advJobDesc,
// //     required this.advQualifications,
// //     required this.advAddInformation,
// //     required this.advExpirationDate,
// //     required this.advPhoto,
// //     required this.advPaymentInfo,
// //   });

// //   factory Savedlistmodel.fromJson(Map<String, dynamic> json) {
// //     return Savedlistmodel(
// //       compId: json['compId'] ?? 0,
// //       advertId: json['advertId'] ?? 1,
// //       advTitle: json['advTitle'] ?? 'Başlık Yok',
// //       advAdressTitle: json['advAdressTitle'] ?? 'Adres Yok',
// //       advAdress: json['advAdress'] ?? 'Adres Yok',
// //       advWorkType: json['advWorkType'] ?? 'Belirtilmemiş',
// //       advDepartment: json['advDepartment'] ?? 'Belirtilmemiş',
// //       advJobDesc: json['advJobDesc'] ?? 'Açıklama Yok',
// //       advQualifications: json['advQualifications'] ?? 'Nitelik Yok',
// //       advAddInformation: json['advAddInformation'] ?? 'Ek Bilgi Yok',
// //       advExpirationDate: DateTime.parse(json['advExpirationDate'] ?? DateTime.now().toIso8601String()),
// //       advPhoto: json['advPhoto'] ?? '',
// //       advPaymentInfo: json['advPaymentInfo'] ?? false,

// //     );
// //   }
// // }


// import 'package:flutter/services.dart';

// class Savedlistmodel {
//   int? advertId;
//   int? compId;
//   String? advTitle;
//   String? advAdress;
//   String? advWorkType;
//   String? advDepartment;
//   String? advDesc;
//   String? advQualifications;
//   String? advAddInformation;
//   String? advJobDesc;
//   String? advExpirationDate;
//   bool? advIsActive;
//   String? advPhoto;
//   String? advAdressTitle;
//   bool? advPaymentInfo;
//   Company? comp;
//   List<dynamic>? applications;
//   List<dynamic>? usersSavedAdverts;

//   Savedlistmodel({
//     this.advertId,
//     this.compId,
//     this.advTitle,
//     this.advAdress,
//     this.advWorkType,
//     this.advDepartment,
//     this.advDesc,
//     this.advQualifications,
//     this.advAddInformation,
//     this.advJobDesc,
//     this.advExpirationDate,
//     this.advIsActive,
//     this.advPhoto,
//     this.advAdressTitle,
//     this.advPaymentInfo,
//     this.comp,
//     this.applications,
//     this.usersSavedAdverts,
//   });

//   Savedlistmodel.fromJson(Map<String, dynamic> json) {
//     advertId = json['advertId']?.toInt();
//     compId = json['compId']?.toInt();
//     advTitle = json['advTitle']?.toString();
//     advAdress = json['advAdress']?.toString();
//     advWorkType = json['advWorkType']?.toString();
//     advDepartment = json['advDepartment']?.toString();
//     advDesc = json['advDesc']?.toString();
//     advJobDesc = json['advJobDesc']?.toString();
//     advQualifications = json['advQualifications']?.toString();
//     advAddInformation = json['advAddInformation']?.toString();
//     advExpirationDate = json['advExpirationDate']?.toString();
//     advIsActive = json['advIsActive'];
//     advPhoto = json['advPhoto']?.toString();
//     advAdressTitle = json['advAdressTitle']?.toString();
//     advPaymentInfo = json['advPaymentInfo'];
//     applications = json['applications']?['values'] ?? [];
//     usersSavedAdverts = json['usersSavedAdverts']?['values'] ?? [];
//     comp = json['comp'] != null ? Company.fromJson(json['comp']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['advertId'] = advertId;
//     data['compId'] = compId;
//     data['advTitle'] = advTitle;
//     data['advAdress'] = advAdress;
//     data['advWorkType'] = advWorkType;
//     data['advDepartment'] = advDepartment;
//     data['advDesc'] = advDesc;
//     data['advAddInformation'] = advAddInformation;
//     data['advJobDesc'] = advJobDesc;
//     data['advQualifications'] = advQualifications;
//     data['advExpirationDate'] = advExpirationDate;
//     data['advIsActive'] = advIsActive;
//     data['advPhoto'] = advPhoto;
//     data['advAdressTitle'] = advAdressTitle;
//     data['advPaymentInfo'] = advPaymentInfo;
//     data['applications'] = {'\$values': applications};
//     data['usersSavedAdverts'] = {'\$values': usersSavedAdverts};
//     if (comp != null) {
//       data['comp'] = comp!.toJson();
//     }
//     return data;
//   }
// }

// class Company {
//   int? compId;
//   String? compName;
//   String? compFoundationYear;
//   String? compWebSite;
//   String? compContactMail;
//   String? compAdress;
//   String? compAddressTitle;
//   String? compSektor;
//   String? compDesc;
//   String? advAddInformation;
//   String? compLogo;
//   String? comLinkedin;
//   int? compEmployeeCount;
//   int? compUserId;
//   List<dynamic>? advertisements;
//   dynamic compUser;

//   Company({
//     this.compId,
//     this.compName,
//     this.compFoundationYear,
//     this.compWebSite,
//     this.compContactMail,
//     this.compAdress,
//     this.compAddressTitle,
//     this.compSektor,
//     this.compDesc,
//     this.advAddInformation,
//     this.compLogo,
//     this.comLinkedin,
//     this.compEmployeeCount,
//     this.compUserId,
//     this.advertisements,
//     this.compUser,
//   });

//   Company.fromJson(Map<String, dynamic> json) {
//     compId = json['compId']?.toInt();
//     compName = json['compName']?.toString();
//     compFoundationYear = json['compFoundationYear']?.toString();
//     compWebSite = json['compWebSite']?.toString();
//     compContactMail = json['compContactMail']?.toString();
//     compAdress = json['compAdress']?.toString();
//     compAddressTitle = json['compAddressTitle']?.toString();
//     compSektor = json['compSektor']?.toString();
//     compDesc = json['compDesc']?.toString();
//     compLogo = json['compLogo']?.toString();
//     comLinkedin = json['comLinkedin']?.toString();
//     compEmployeeCount = json['compEmployeeCount']?.toInt();
//     compUserId = json['compUserId']?.toInt();
//     advertisements = json['advertisements']?['values'] ?? [];
//     compUser = json['compUser'];
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['compId'] = compId;
//     data['compName'] = compName;
//     data['compFoundationYear'] = compFoundationYear;
//     data['compWebSite'] = compWebSite;
//     data['compContactMail'] = compContactMail;
//     data['compAdress'] = compAdress;
//     data['compAddressTitle'] = compAddressTitle;
//     data['compSektor'] = compSektor;
//     data['compDesc'] = compDesc;
//     data['compLogo'] = compLogo;
//     data['comLinkedin'] = comLinkedin;
//     data['compEmployeeCount'] = compEmployeeCount;
//     data['compUserId'] = compUserId;
//     data['advertisements'] = {'\$values': advertisements};
//     data['compUser'] = compUser;
//     return data;
//   }
// }
