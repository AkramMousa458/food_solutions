import 'package:food_solutions/features/auth/data/models/auth_user_model.dart';

class VerifyOtpResponseModel {
  final bool isSuccess;
  final String message;
  final bool isVerified;
  final AuthUserModel? user;
  final String? token;

  const VerifyOtpResponseModel({
    required this.isSuccess,
    required this.message,
    required this.isVerified,
    this.user,
    this.token,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    final token = json['token'];
    return VerifyOtpResponseModel(
      isSuccess: json['success'] == true,
      message: message is String ? message : '',
      isVerified: json['verified'] == true,
      user: _readUser(json['user']),
      token: token is String && token.isNotEmpty ? token : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': isSuccess,
      'message': message,
      'verified': isVerified,
      'user': user?.toJson(),
      'token': token,
    };
  }
}

AuthUserModel? _readUser(Object? value) {
  if (value is! Map) return null;
  return AuthUserModel.fromJson(Map<String, dynamic>.from(value));
}
