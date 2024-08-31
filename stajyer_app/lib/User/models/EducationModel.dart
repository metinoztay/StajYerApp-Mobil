class EducationModel {
  final int eduId;
  final int userId;
  final int uniId;
  String? uniName; // uniName'i nullable yapmışsınız
  final int progId;
  final String? eduStartDate;
  final String? eduFinishDate;
  final double? eduGano;
  final String? eduSituation;
  final String? eduDesc;

  EducationModel({
    required this.eduId,
    required this.userId,
    required this.uniId,
    this.uniName,
    required this.progId,
    this.eduStartDate,
    this.eduFinishDate,
    this.eduGano,
    this.eduSituation,
    this.eduDesc,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      eduId: json['eduId'],
      userId: json['userId'],
      uniId: json['uniId'],
      uniName: json['uniName'], // uniName'i JSON'dan al
      progId: json['progId'],
      eduStartDate: json['eduStartDate'],
      eduFinishDate: json['eduFinishDate'],
      eduGano: (json['eduGano'] as num?)?.toDouble(),
      eduSituation: json['eduSituation'],
      eduDesc: json['eduDesc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eduId': eduId,
      'userId': userId,
      'uniId': uniId,
      'uniName': uniName, // uniName'i JSON'a ekle
      'progId': progId,
      'eduStartDate': eduStartDate,
      'eduFinishDate': eduFinishDate,
      'eduGano': eduGano,
      'eduSituation': eduSituation,
      'eduDesc': eduDesc,
    };
  }

  static List<EducationModel> fromJsonList(Map<String, dynamic> json) {
    final jsonList = json['\$values'] as List<dynamic>;
    return jsonList
        .map((jsonItem) =>
            EducationModel.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
  }
}
