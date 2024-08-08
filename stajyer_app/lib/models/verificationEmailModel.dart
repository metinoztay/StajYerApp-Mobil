class VerificationRequest {
  final String userId;
  final String? verificationCode;

  VerificationRequest({required this.userId, this.verificationCode});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    if (verificationCode != null) {
      data['Code'] = verificationCode; // 'Code' olarak gönder
    }
    return data;
  }
}
