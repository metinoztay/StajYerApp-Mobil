class CompanyRegisterModel {
  String? nameSurname;
  String? phone;
  String? email;
  String? taxNumber;
  int? taxCityId;
  int? taxOfficeId;

  CompanyRegisterModel(
      {this.nameSurname,
      this.phone,
      this.email,
      this.taxNumber,
      this.taxCityId,
      this.taxOfficeId});

  CompanyRegisterModel.fromJson(Map<String, dynamic> json) {
    nameSurname = json['nameSurname'];
    phone = json['phone'];
    email = json['email'];
    taxNumber = json['taxNumber'];
    taxCityId = json['taxCityId'];
    taxOfficeId = json['taxOfficeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameSurname'] = this.nameSurname;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['taxNumber'] = this.taxNumber;
    data['taxCityId'] = this.taxCityId;
    data['taxOfficeId'] = this.taxOfficeId;
    return data;
  }
}
