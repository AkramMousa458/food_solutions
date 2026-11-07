class DeleteEstablishmentResponse {
  final bool isSuccess;
  final String message;

  const DeleteEstablishmentResponse({
    required this.isSuccess,
    required this.message,
  });

  factory DeleteEstablishmentResponse.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    return DeleteEstablishmentResponse(
      isSuccess: json['success'] == true,
      message: message is String ? message.trim() : '',
    );
  }
}
