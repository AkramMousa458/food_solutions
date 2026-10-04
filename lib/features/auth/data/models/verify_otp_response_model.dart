class VerifyOtpResponseModel {
  final bool isSuccess;
  final String message;
  final bool isVerified;
  final String? token;

  const VerifyOtpResponseModel({
    required this.isSuccess,
    required this.message,
    required this.isVerified,
    this.token,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    final token = json['token'];
    return VerifyOtpResponseModel(
      isSuccess: json['success'] == true,
      message: message is String ? message : '',
      isVerified: json['verified'] == true,
      token: token is String && token.isNotEmpty ? token : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': isSuccess,
      'message': message,
      'verified': isVerified,
      'user': null,
      'token': token,
    };
  }
}
