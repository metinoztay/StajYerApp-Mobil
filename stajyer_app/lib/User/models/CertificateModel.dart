class CertificateModel {
  int? certId;
  int? userId;
  String? certName;
  String? cerCompanyName;
  String? certDesc;
  String? certDate;

  CertificateModel({
    this.certId,
    this.userId,
    this.certName,
    this.cerCompanyName,
    this.certDesc,
    this.certDate,
  });

  CertificateModel.fromJson(Map<String, dynamic> json) {
    certId = json['certId'];
    userId = json['userId'];
    certName = json['certName'];
    cerCompanyName = json['cerCompanyName'];
    certDesc = json['certDesc'];
    certDate = json['certDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['certId'] = this.certId ?? 0;
    data['userId'] = this.userId;
    data['certName'] = this.certName;
    data['cerCompanyName'] = this.cerCompanyName;
    data['certDesc'] = this.certDesc;
    data['certDate'] = this.certDate;
    return data;
  }

  static List<CertificateModel> fromJsonList(Map<String, dynamic> json) {
    if (json.containsKey('\$values')) {
      List<dynamic> values = json['\$values'];
      return values.map((item) => CertificateModel.fromJson(item)).toList();
    } else {
      throw Exception('JSON formatı beklenmedik bir şekilde: $json');
    }
  }
}