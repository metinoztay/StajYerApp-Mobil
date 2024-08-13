class CompAdvModel {
  final int compUserId;
  final String advTitle;
  final String advAdress;
  final String advWorkType;
  final String advDepartment;
  final DateTime advExpirationDate;
  final String advPhoto;
  final String advAdressTitle;
  final bool advPaymentInfo;
  final String advJobDesc;
  final String advQualifications;
  final String advAddInformation;

  CompAdvModel({
    required this.compUserId,
    required this.advTitle,
    required this.advAdress,
    required this.advWorkType,
    required this.advDepartment,
    required this.advExpirationDate,
    required this.advPhoto,
    required this.advAdressTitle,
    required this.advPaymentInfo,
    required this.advJobDesc,
    required this.advQualifications,
    required this.advAddInformation,
  });

  factory CompAdvModel.fromJson(Map<String, dynamic> json) {
    return CompAdvModel(
      compUserId: json['compUserId'],
      advTitle: json['advTitle'],
      advAdress: json['advAdress'],
      advWorkType: json['advWorkType'],
      advDepartment: json['advDepartment'],
      advExpirationDate: DateTime.parse(json['advExpirationDate']),
      advPhoto: json['advPhoto'],
      advAdressTitle: json['advAdressTitle'],
      advPaymentInfo: json['advPaymentInfo'],
      advJobDesc: json['advJobDesc'],
      advQualifications: json['advQualifications'],
      advAddInformation: json['advAddInformation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compUserId': compUserId,
      'advTitle': advTitle,
      'advAdress': advAdress,
      'advWorkType': advWorkType,
      'advDepartment': advDepartment,
      'advExpirationDate': advExpirationDate.toIso8601String(),
      'advPhoto': advPhoto,
      'advAdressTitle': advAdressTitle,
      'advPaymentInfo': advPaymentInfo,
      'advJobDesc': advJobDesc,
      'advQualifications': advQualifications,
      'advAddInformation': advAddInformation,
    };
  }
}
