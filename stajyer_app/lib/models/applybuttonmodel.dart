class ApplyButtonModel {
  final int userId;
  final int advertId;

  ApplyButtonModel({required this.userId, required this.advertId});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'advertId': advertId,
    };
  }
}
