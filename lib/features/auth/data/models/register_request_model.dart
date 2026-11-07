class RegisterRequestModel {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String passwordConfirmation;

  const RegisterRequestModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final phone = json['phone'];
    final email = json['email'];
    final password = json['password'];
    final passwordConfirmation = json['password_confirmation'];
    return RegisterRequestModel(
      name: name is String ? name : '',
      phone: phone is String ? phone : '',
      email: email is String ? email : '',
      password: password is String ? password : '',
      passwordConfirmation: passwordConfirmation is String
          ? passwordConfirmation
          : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}
