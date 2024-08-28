class ExperienceModel {
  int? expId;
  int? userId;
  String? expPosition;
  String? expCompanyName;
  int? expCityId;
  String? expStartDate;
  String? expFinishDate;
  String? expWorkType;
  String? expDesc;

  ExperienceModel(
      {this.expId,
      this.userId,
      this.expPosition,
      this.expCompanyName,
      this.expCityId,
      this.expStartDate,
      this.expFinishDate,
      this.expWorkType,
      this.expDesc});

  ExperienceModel.fromJson(Map<String, dynamic> json) {
    expId = json['expId'];
    userId = json['userId'];
    expPosition = json['expPosition'];
    expCompanyName = json['expCompanyName'];
    expCityId = json['expCityId'];
    expStartDate = json['expStartDate'];
    expFinishDate = json['expFinishDate'];
    expWorkType = json['expWorkType'];
    expDesc = json['expDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expId'] = expId ?? 0;
    data['userId'] = this.userId;
    data['expPosition'] = this.expPosition;
    data['expCompanyName'] = this.expCompanyName;
    data['expCityId'] = this.expCityId;
    data['expStartDate'] = this.expStartDate;
    data['expFinishDate'] = this.expFinishDate;
    data['expWorkType'] = this.expWorkType;
    data['expDesc'] = this.expDesc;
    return data;
  }

  static List<ExperienceModel> fromJsonList(Map<String, dynamic> json) {
    //Burada json deki \$values kısmını dolaşıyoruz.
    if (json.containsKey('\$values')) {
      List<dynamic> values = json['\$values'];
      return values.map((item) => ExperienceModel.fromJson(item)).toList();
    } else {
      throw Exception('JSON formatı beklenmedik bir şekilde: $json');
    }
  }
}
