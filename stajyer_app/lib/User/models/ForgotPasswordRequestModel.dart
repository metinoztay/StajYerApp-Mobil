class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  // JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}