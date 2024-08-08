class CompanyModel {
  int? compId;
  String? compName;
  String? compFoundationYear;
  String? compWebSite;
  String? compContactMail;
  String? compAdress;
  String? compAddressTitle;
  String? compSektor;
  String? compDesc;
  String? compLogo;
  String? comLinkedin;
  int? compEmployeeCount;

  CompanyModel(
      {this.compId,
      this.compName,
      this.compFoundationYear,
      this.compWebSite,
      this.compContactMail,
      this.compAdress,
      this.compSektor,
      this.compDesc,
      this.compLogo,
      this.comLinkedin,
      this.compEmployeeCount,
      this.compAddressTitle});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    compId = json['compId'];
    compName = json['compName'];
    compFoundationYear = json['compFoundationYear'];
    compWebSite = json['compWebSite'];
    compContactMail = json['compContactMail'];
    compAdress = json['compAdress'];
    compSektor = json['compSektor'];
    compDesc = json['compDesc'];
    compLogo = json['compLogo'];
    comLinkedin = json['comLinkedin'];
    compEmployeeCount = json['compEmployeeCount'];
    compAddressTitle = json['compAddressTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compId'] = this.compId;
    data['compName'] = this.compName;
    data['compFoundationYear'] = this.compFoundationYear;
    data['compWebSite'] = this.compWebSite;
    data['compContactMail'] = this.compContactMail;
    data['compAdress'] = this.compAdress;
    data['compSektor'] = this.compSektor;
    data['compDesc'] = this.compDesc;
    data['compLogo'] = this.compLogo;
    data['comLinkedin'] = this.comLinkedin;
    data['compEmployeeCount'] = this.compEmployeeCount;
    data['compAddressTitle'] = this.compAddressTitle;

    return data;
  }
}
// class Values {
//   int? compId;
//   String? compName;
//   String? compFoundationYear;
//   String? compWebSite;
//   String? compContactMail;
//   String? compAdress;
//   String? compSektor;
//   String? compDesc;
//   String? compLogo;
//   String? comLinkedin;
//   int? compEmployeeCount;
//   Advertisements? advertisements;

//   Values(
//       {this.compId,
//       this.compName,
//       this.compFoundationYear,
//       this.compWebSite,
//       this.compContactMail,
//       this.compAdress,
//       this.compSektor,
//       this.compDesc,
//       this.compLogo,
//       this.comLinkedin,
//       this.compEmployeeCount,
//       this.advertisements});

//   Values.fromJson(Map<String, dynamic> json) {
//     compId = json['compId'];
//     compName = json['compName'];
//     compFoundationYear = json['compFoundationYear'];
//     compWebSite = json['compWebSite'];
//     compContactMail = json['compContactMail'];
//     compAdress = json['compAdress'];
//     compSektor = json['compSektor'];
//     compDesc = json['compDesc'];
//     compLogo = json['compLogo'];
//     comLinkedin = json['comLinkedin'];
//     compEmployeeCount = json['compEmployeeCount'];
//     advertisements = json['advertisements'] != null
//         ? new Advertisements.fromJson(json['advertisements'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['compId'] = this.compId;
//     data['compName'] = this.compName;
//     data['compFoundationYear'] = this.compFoundationYear;
//     data['compWebSite'] = this.compWebSite;
//     data['compContactMail'] = this.compContactMail;
//     data['compAdress'] = this.compAdress;
//     data['compSektor'] = this.compSektor;
//     data['compDesc'] = this.compDesc;
//     data['compLogo'] = this.compLogo;
//     data['comLinkedin'] = this.comLinkedin;
//     data['compEmployeeCount'] = this.compEmployeeCount;
//     if (this.advertisements != null) {
//       data['advertisements'] = this.advertisements!.toJson();
//     }
//     return data;
//   }
// }

// class Advertisements {
//   String? id;
//   List<dynamic>? values;

//   Advertisements({this.id, this.values});

//   Advertisements.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     if (json['values'] != null) {
//       values = <dynamic>[];
//       json['values'].forEach((v) {
//         values!.add(v);
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     if (this.values != null) {
//       data['values'] = this.values;
//     }
//     return data;
//   }
// }