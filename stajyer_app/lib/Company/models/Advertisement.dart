class Advertisement {
  final int advertId;
  final int compId;
  final String? advTitle;
  final String? advAdress;
  final String? advWorkType;
  final String? advDepartment;
  final DateTime advExpirationDate;
  final bool advIsActive;
  final String? advPhoto;
  final String? advAdressTitle;
  final bool? advPaymentInfo;
  final String? advJobDesc;
  final String? advQualifications;
  final String? advAddInformation;
  final String? advAppCount;

  Advertisement({
    required this.advertId,
    required this.compId,
    this.advTitle,
    this.advAdress,
    this.advWorkType,
    this.advDepartment,
    required this.advExpirationDate,
    required this.advIsActive,
    this.advPhoto,
    this.advAdressTitle,
    this.advPaymentInfo,
    this.advJobDesc,
    this.advQualifications,
    this.advAddInformation,
    this.advAppCount,
  });
  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      advertId: json['advertId'],
      compId: json['compId'],
      advTitle: json['advTitle'],
      advAdress: json['advAdress'],
      advWorkType: json['advWorkType'],
      advDepartment: json['advDepartment'],
      advExpirationDate: DateTime.parse(json['advExpirationDate']),
      advIsActive: json['advIsActive'],
      advPhoto: json['advPhoto'],
      advAdressTitle: json['advAdressTitle'],
      advPaymentInfo: json['advPaymentInfo'],
      advJobDesc: json['advJobDesc'],
      advQualifications: json['advQualifications'],
      advAddInformation: json['advAddInformation'],
      advAppCount: json['advAppCount'],
      // applications: (json['applications'] as List<dynamic>?)
      //     ?.map((app) => Application.fromJson(app))
      //     .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'advertId': advertId,
      'compId': compId,
      'advTitle': advTitle,
      'advAdress': advAdress,
      'advWorkType': advWorkType,
      'advDepartment': advDepartment,
      'advExpirationDate': advExpirationDate.toIso8601String(),
      'advIsActive': advIsActive,
      'advPhoto': advPhoto,
      'advAdressTitle': advAdressTitle,
      'advPaymentInfo': advPaymentInfo,
      'advJobDesc': advJobDesc,
      'advQualifications': advQualifications,
      'advAddInformation': advAddInformation,
      'advAppCount': advAppCount,
      // 'applications': applications?.map((app) => app.toJson()).toList(),
    };
  }
}
