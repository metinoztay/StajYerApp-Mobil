class ApplicationModel {
  final int appId;
  final int userId;
  final int advertId;
  final String appDate;
  final String appLetter;

  ApplicationModel({
    required this.appId,
    required this.userId,
    required this.advertId,
    required this.appDate,
    required this.appLetter,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      appId: json['appId'],
      userId: json['userId'],
      advertId: json['advertId'],
      appDate: json['appDate'],
      appLetter: json['appLetter'],
    );
  }
}
