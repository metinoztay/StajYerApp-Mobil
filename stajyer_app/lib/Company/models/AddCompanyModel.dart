class AddCompanyModel {
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
  int? compUserId;

  AddCompanyModel(
      {this.compName,
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
      this.compUserId});

  AddCompanyModel.fromJson(Map<String, dynamic> json) {
    compName = json['compName'];
    compFoundationYear = json['compFoundationYear'];
    compWebSite = json['compWebSite'];
    compContactMail = json['compContactMail'];
    compAdress = json['compAdress'];
    compAddressTitle = json['compAddressTitle'];
    compSektor = json['compSektor'];
    compDesc = json['compDesc'];
    compLogo = json['compLogo'];
    comLinkedin = json['comLinkedin'];
    compEmployeeCount = json['compEmployeeCount'];
    compUserId = json['compUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compName'] = this.compName;
    data['compFoundationYear'] = this.compFoundationYear;
    data['compWebSite'] = this.compWebSite;
    data['compContactMail'] = this.compContactMail;
    data['compAdress'] = this.compAdress;
    data['compAddressTitle'] = this.compAddressTitle;
    data['compSektor'] = this.compSektor;
    data['compDesc'] = this.compDesc;
    data['compLogo'] = this.compLogo;
    data['comLinkedin'] = this.comLinkedin;
    data['compEmployeeCount'] = this.compEmployeeCount;
    data['compUserId'] = this.compUserId;
    return data;
  }
}
