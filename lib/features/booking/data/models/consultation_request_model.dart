class ConsultationRequestModel {
  final String name;
  final String phone;
  final String? email;
  final int serviceId;
  final String message;

  ConsultationRequestModel({
    required this.name,
    required this.phone,
    this.email,
    required this.serviceId,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email ?? '',
      'service_id': serviceId,
      'message': message,
    };
  }
}
