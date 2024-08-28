class CompForgotPasswordModel {
  final String email;

  CompForgotPasswordModel({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
