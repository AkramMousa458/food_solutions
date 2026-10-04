class LoginRequestModel {
  final String emailOrPhone;
  final String password;

  const LoginRequestModel({required this.emailOrPhone, required this.password});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    final emailOrPhone = json['email_or_phone'];
    final password = json['password'];
    return LoginRequestModel(
      emailOrPhone: emailOrPhone is String ? emailOrPhone : '',
      password: password is String ? password : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'email_or_phone': emailOrPhone, 'password': password};
  }
}
