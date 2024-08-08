class UnivercityModel {
  int? uniId;
  String? uniName;

  UnivercityModel({this.uniId, this.uniName});

  UnivercityModel.fromJson(Map<String, dynamic> json) {
    uniId = json['uniId'];
    uniName = json['uniName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uniId'] = this.uniId;
    data['uniName'] = this.uniName;
    return data;
  }
}