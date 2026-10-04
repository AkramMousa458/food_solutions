import 'package:food_solutions/features/auth/data/models/auth_user_model.dart';

class RegisterResponseModel {
  final bool isSuccess;
  final String message;
  final bool requiresVerification;
  final String identifier;
  final AuthUserModel? user;

  const RegisterResponseModel({
    required this.isSuccess,
    required this.message,
    required this.requiresVerification,
    required this.identifier,
    this.user,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    final identifier = json['identifier'];
    return RegisterResponseModel(
      isSuccess: json['success'] == true,
      message: message is String ? message : '',
      requiresVerification: json['requires_verification'] == true,
      identifier: identifier is String ? identifier : '',
      user: _readUser(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': isSuccess,
      'message': message,
      'requires_verification': requiresVerification,
      'identifier': identifier,
      'user': user?.toJson(),
    };
  }
}

AuthUserModel? _readUser(Object? value) {
  if (value is! Map) return null;
  return AuthUserModel.fromJson(Map<String, dynamic>.from(value));
}
