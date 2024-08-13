class UpdateAdvertModel {
  final int advertId;
  final int compId;
  final String advTitle;
  final String advAdress;
  final String advWorkType;
  final String advDepartment;
  final DateTime advExpirationDate;
  final bool advIsActive;
  final String advPhoto;
  final String advAdressTitle;
  final bool advPaymentInfo;
  final String advJobDesc;
  final String advQualifications;
  final String advAddInformation;
  final String advAppCount;
  final bool isApplied;

  UpdateAdvertModel({
    required this.advertId,
    required this.compId,
    required this.advTitle,
    required this.advAdress,
    required this.advWorkType,
    required this.advDepartment,
    required this.advExpirationDate,
    required this.advIsActive,
    required this.advPhoto,
    required this.advAdressTitle,
    required this.advPaymentInfo,
    required this.advJobDesc,
    required this.advQualifications,
    required this.advAddInformation,
    required this.advAppCount,
    required this.isApplied,
  });

  factory UpdateAdvertModel.fromJson(Map<String, dynamic> json) {
    return UpdateAdvertModel(
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
      isApplied: json['isApplied'],
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
      'isApplied': isApplied,
    };
  }
}
