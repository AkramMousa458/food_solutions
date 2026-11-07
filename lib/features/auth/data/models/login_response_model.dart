import 'package:food_solutions/features/auth/data/models/auth_user_model.dart';

class LoginResponseModel {
  final String token;
  final AuthUserModel user;

  const LoginResponseModel({required this.token, required this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    final user = json['user'];
    return LoginResponseModel(
      token: token is String ? token : '',
      user: user is Map
          ? AuthUserModel.fromJson(Map<String, dynamic>.from(user))
          : const AuthUserModel(
              id: 0,
              name: '',
              email: '',
              phone: '',
              role: '',
              establishments: [],
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user.toJson()};
  }
}
