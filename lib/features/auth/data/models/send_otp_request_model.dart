class SendOtpRequestModel {
  static const String emailType = 'email';

  final String identifier;
  final String type;

  const SendOtpRequestModel({required this.identifier, this.type = emailType});

  factory SendOtpRequestModel.fromJson(Map<String, dynamic> json) {
    final identifier = json['identifier'];
    final type = json['type'];
    return SendOtpRequestModel(
      identifier: identifier is String ? identifier : '',
      type: type is String && type.isNotEmpty ? type : emailType,
    );
  }

  Map<String, dynamic> toJson() {
    return {'identifier': identifier, 'type': type};
  }
}
