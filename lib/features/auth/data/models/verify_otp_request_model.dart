class VerifyOtpRequestModel {
  final String identifier;
  final String code;

  const VerifyOtpRequestModel({required this.identifier, required this.code});

  factory VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) {
    final identifier = json['identifier'];
    final code = json['code'];
    return VerifyOtpRequestModel(
      identifier: identifier is String ? identifier : '',
      code: code is String ? code : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'identifier': identifier, 'code': code};
  }
}
