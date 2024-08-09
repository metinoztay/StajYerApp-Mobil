class CompUserNewPasswordModel {
  final int compUserId;
  final String oldPassword;
  final String newPassword;

  CompUserNewPasswordModel({
    required this.compUserId,
    required this.oldPassword,
    required this.newPassword,
  }); 

  // JSON'dan model oluşturma
  factory CompUserNewPasswordModel.fromJson(Map<String, dynamic> json) {
    return CompUserNewPasswordModel(
      compUserId: json['compUserId'],
      oldPassword: json['oldPassword'],
      newPassword: json['newPassword'],
    );
  }

  // Modeli JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'compUserId': compUserId,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }
}
