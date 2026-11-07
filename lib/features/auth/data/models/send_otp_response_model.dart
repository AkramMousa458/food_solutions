class SendOtpResponseModel {
  final bool isSuccess;
  final String message;
  final String identifier;
  final String type;
  final DateTime? expiresAt;
  final String? code;

  const SendOtpResponseModel({
    required this.isSuccess,
    required this.message,
    required this.identifier,
    required this.type,
    this.expiresAt,
    this.code,
  });

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    final identifier = json['identifier'];
    final type = json['type'];
    final expiresAt = json['expires_at'];
    return SendOtpResponseModel(
      isSuccess: json['success'] == true,
      message: message is String ? message : '',
      identifier: identifier is String ? identifier : '',
      type: type is String ? type : '',
      expiresAt: expiresAt is String ? DateTime.tryParse(expiresAt) : null,
      code: _readCode(json['code']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': isSuccess,
      'message': message,
      'identifier': identifier,
      'type': type,
      'expires_at': expiresAt?.toIso8601String(),
      'code': code,
    };
  }
}

String? _readCode(Object? value) {
  if (value is String && value.isNotEmpty) return value;
  if (value is num) return value.toString();
  return null;
}
