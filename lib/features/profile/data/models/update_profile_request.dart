class UpdateProfileRequest {
  final String name;
  final String phone;
  final String email;

  const UpdateProfileRequest({
    required this.name,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'email': email};
  }
}
