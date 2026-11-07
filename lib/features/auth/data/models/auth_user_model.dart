class AuthEstablishmentModel {
  final int id;
  final String name;

  const AuthEstablishmentModel({required this.id, required this.name});

  factory AuthEstablishmentModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    return AuthEstablishmentModel(
      id: id is int ? id : int.tryParse('$id') ?? 0,
      name: name is String ? name : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class AuthUserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AuthEstablishmentModel> establishments;

  const AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.establishments,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final email = json['email'];
    final phone = json['phone'];
    final role = json['role'];
    return AuthUserModel(
      id: id is int ? id : int.tryParse('$id') ?? 0,
      name: name is String ? name : '',
      email: email is String ? email : '',
      phone: phone is String ? phone : '',
      emailVerifiedAt: _readDate(json['email_verified_at']),
      phoneVerifiedAt: _readDate(json['phone_verified_at']),
      role: role is String ? role : '',
      createdAt: _readDate(json['created_at']),
      updatedAt: _readDate(json['updated_at']),
      establishments: _readEstablishments(json['establishments']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'phone_verified_at': phoneVerifiedAt?.toIso8601String(),
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'establishments': establishments.map((item) => item.toJson()).toList(),
    };
  }
}

DateTime? _readDate(Object? value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

List<AuthEstablishmentModel> _readEstablishments(Object? value) {
  if (value is! List) return const [];
  return value.whereType<Map>().map((item) {
    return AuthEstablishmentModel.fromJson(Map<String, dynamic>.from(item));
  }).toList();
}
