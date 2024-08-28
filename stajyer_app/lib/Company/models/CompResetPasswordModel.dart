class CompResetPasswordModel {
  final String email;
  final String code;
  final String newPassword;

  CompResetPasswordModel(
      {required this.email, required this.code, required this.newPassword});
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
      'newPassword': newPassword,
    };
  }
}
