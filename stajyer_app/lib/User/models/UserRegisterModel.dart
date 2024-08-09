class UserRegisterModel {
  String? uname;
  String? usurname;
  String? uemail;
  String? upassword;
  String? ubirthdate;
  bool? ugender;

  UserRegisterModel(
      {this.uname,
      this.usurname,
      this.uemail,
      this.upassword,
      this.ubirthdate,
      this.ugender});

  UserRegisterModel.fromJson(Map<String, dynamic> json) {
    uname = json['uname'];
    usurname = json['usurname'];
    uemail = json['uemail'];
    upassword = json['upassword'];
    ubirthdate = json['ubirthdate'];
    ugender = json['ugender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uname'] = this.uname;
    data['usurname'] = this.usurname;
    data['uemail'] = this.uemail;
    data['upassword'] = this.upassword;
    data['ubirthdate'] = this.ubirthdate;
    data['ugender'] = this.ugender;
    return data;
  }
}
