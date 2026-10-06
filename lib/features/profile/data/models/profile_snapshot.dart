import 'package:equatable/equatable.dart';

class ProfileEstablishmentSnapshot extends Equatable {
  final int? id;
  final String name;
  final String? phone;
  final String? headquarters;
  final String? activity;
  final String? ageLabel;
  final int? ageInMonths;
  final String? imageUrl;
  final String? userPosition;
  final String? status;
  final bool isActive;

  const ProfileEstablishmentSnapshot({
    required this.name,
    required this.isActive,
    this.id,
    this.phone,
    this.headquarters,
    this.activity,
    this.ageLabel,
    this.ageInMonths,
    this.imageUrl,
    this.userPosition,
    this.status,
  });

  factory ProfileEstablishmentSnapshot.fromJson(Map<String, dynamic> json) {
    return ProfileEstablishmentSnapshot(
      id: _readId(json['id']),
      name: _readString(json['name']),
      phone: _readOptionalString(json['phone']),
      headquarters: _readOptionalString(
        json['address'] ?? json['headquarters'] ?? json['city'],
      ),
      activity: _readOptionalString(
        json['business_activity'] ?? json['activity'],
      ),
      ageLabel: _readAgeLabel(json['age']),
      ageInMonths: _readMonths(json['age_in_months']),
      imageUrl: _readOptionalString(json['image']),
      userPosition: _readOptionalString(json['user_position']),
      status: _readOptionalString(json['status']),
      isActive: _readActive(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': headquarters,
      'business_activity': activity,
      'age': ageLabel,
      'age_in_months': ageInMonths,
      'image': imageUrl,
      'user_position': userPosition,
      'status': status,
      'is_active': isActive,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    headquarters,
    activity,
    ageLabel,
    ageInMonths,
    imageUrl,
    userPosition,
    status,
    isActive,
  ];
}

class ProfileSnapshot extends Equatable {
  final String name;
  final String role;
  final String phone;
  final String email;
  final String? phoneVerifiedAt;
  final String? emailVerifiedAt;
  final String initials;
  final List<ProfileEstablishmentSnapshot> establishments;

  const ProfileSnapshot({
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.initials,
    this.phoneVerifiedAt,
    this.emailVerifiedAt,
    this.establishments = const [],
  });

  bool get isPhoneVerified =>
      phoneVerifiedAt != null && phoneVerifiedAt!.isNotEmpty;

  bool get isEmailVerified =>
      emailVerifiedAt != null && emailVerifiedAt!.isNotEmpty;

  factory ProfileSnapshot.fromJson(Map<String, dynamic> json) {
    final name = _readString(json['name']);
    return ProfileSnapshot(
      name: name,
      role: _readString(json['role']),
      phone: _readString(json['phone']),
      email: _readString(json['email']),
      phoneVerifiedAt: _readOptionalString(json['phone_verified_at']),
      emailVerifiedAt: _readOptionalString(json['email_verified_at']),
      initials: _initialsFrom(name),
      establishments: _readEstablishments(json['establishments']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'phone': phone,
      'email': email,
      'phone_verified_at': phoneVerifiedAt,
      'email_verified_at': emailVerifiedAt,
      'establishments': establishments.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    name,
    role,
    phone,
    email,
    phoneVerifiedAt,
    emailVerifiedAt,
    initials,
    establishments,
  ];
}

String _readString(Object? value) {
  if (value is! String) return '';
  return value.trim();
}

String? _readOptionalString(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  return trimmed;
}

int? _readId(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

String? _readAgeLabel(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty || int.tryParse(trimmed) != null) return null;
  return trimmed;
}

int? _readMonths(Object? value) {
  if (value is int && value >= 0) return value;
  if (value is num && value >= 0) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

bool _readActive(Map<String, dynamic> json) {
  final value = json['is_active'];
  if (value is bool) return value;
  final status = json['status'];
  if (status is String && status.trim().isNotEmpty) {
    return status.trim().toLowerCase() == 'active';
  }
  return true;
}

List<ProfileEstablishmentSnapshot> _readEstablishments(Object? value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) {
        return ProfileEstablishmentSnapshot.fromJson(
          Map<String, dynamic>.from(item),
        );
      })
      .where((item) => item.name.isNotEmpty)
      .toList();
}

String _initialsFrom(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '';
  final first = _firstRune(parts.first);
  if (parts.length == 1) return first.toUpperCase();
  return '$first${_firstRune(parts.last)}'.toUpperCase();
}

String _firstRune(String value) {
  final iterator = value.runes.iterator;
  if (!iterator.moveNext()) return '';
  return String.fromCharCode(iterator.current);
}
