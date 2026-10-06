import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

class CreateEstablishmentResponse {
  final bool isSuccess;
  final String message;
  final ProfileEstablishmentSnapshot? establishment;

  const CreateEstablishmentResponse({
    required this.isSuccess,
    required this.message,
    this.establishment,
  });

  factory CreateEstablishmentResponse.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    return CreateEstablishmentResponse(
      isSuccess: json['success'] == true,
      message: message is String ? message.trim() : '',
      establishment: _readEstablishment(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': isSuccess,
      'message': message,
      'data': establishment?.toJson(),
    };
  }
}

ProfileEstablishmentSnapshot? _readEstablishment(Object? value) {
  if (value is! Map) return null;
  final establishment = ProfileEstablishmentSnapshot.fromJson(
    Map<String, dynamic>.from(value),
  );
  if (establishment.name.isEmpty) return null;
  return establishment;
}
