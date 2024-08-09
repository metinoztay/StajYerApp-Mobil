class CompanyAdvModel {
  int? advertId;
  int? compId;
  String? advTitle;
  String? advAdress;
  String? advWorkType;
  String? advDepartment;
  String? advExpirationDate;
  bool? advIsActive;
  String? advPhoto;
  String? advAdressTitle;
  bool? advPaymentInfo;
  String? advJobDesc;
  String? advQualifications;
  String? advAddInformation;

  CompanyAdvModel(
      {this.advertId,
      this.compId,
      this.advTitle,
      this.advAdress,
      this.advWorkType,
      this.advDepartment,
      this.advExpirationDate,
      this.advIsActive,
      this.advPhoto,
      this.advAdressTitle,
      this.advPaymentInfo,
      this.advJobDesc,
      this.advQualifications,
      this.advAddInformation});

  CompanyAdvModel.fromJson(Map<String, dynamic> json) {
    advertId = json['advertId'];
    compId = json['compId'];
    advTitle = json['advTitle'];
    advAdress = json['advAdress'];
    advWorkType = json['advWorkType'];
    advDepartment = json['advDepartment'];
    advExpirationDate = json['advExpirationDate'];
    advIsActive = json['advIsActive'];
    advPhoto = json['advPhoto'];
    advAdressTitle = json['advAdressTitle'];
    advPaymentInfo = json['advPaymentInfo'];
    advJobDesc = json['advJobDesc'];
    advQualifications = json['advQualifications'];
    advAddInformation = json['advAddInformation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['advertId'] = this.advertId;
    data['compId'] = this.compId;
    data['advTitle'] = this.advTitle;
    data['advAdress'] = this.advAdress;
    data['advWorkType'] = this.advWorkType;
    data['advDepartment'] = this.advDepartment;
    data['advExpirationDate'] = this.advExpirationDate;
    data['advIsActive'] = this.advIsActive;
    data['advPhoto'] = this.advPhoto;
    data['advAdressTitle'] = this.advAdressTitle;
    data['advPaymentInfo'] = this.advPaymentInfo;
    data['advJobDesc'] = this.advJobDesc;
    data['advQualifications'] = this.advQualifications;
    data['advAddInformation'] = this.advAddInformation;
    return data;
  }
}