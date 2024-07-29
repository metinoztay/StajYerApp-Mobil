class UserRegisterModel {
  String? uname;
  String? usurname;
  String? uemail;
  String? upassword;
  String? uphone;
  String? ubirthdate;
  bool? ugender;

  UserRegisterModel(
      {this.uname,
      this.usurname,
      this.uemail,
      this.upassword,
      this.uphone,
      this.ubirthdate,
      this.ugender});

  UserRegisterModel.fromJson(Map<String, dynamic> json) {
    uname = json['uname'];
    usurname = json['usurname'];
    uemail = json['uemail'];
    upassword = json['upassword'];
    uphone = json['uphone'];
    ubirthdate = json['ubirthdate'];
    ugender = json['ugender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uname'] = this.uname;
    data['usurname'] = this.usurname;
    data['uemail'] = this.uemail;
    data['upassword'] = this.upassword;
    data['uphone'] = this.uphone;
    data['ubirthdate'] = this.ubirthdate;
    data['ugender'] = this.ugender;
    return data;
  }
}
