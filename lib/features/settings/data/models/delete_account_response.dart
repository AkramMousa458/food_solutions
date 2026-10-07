class DeleteAccountResponse {
  final bool isSuccess;
  final String message;

  const DeleteAccountResponse({
    required this.isSuccess,
    required this.message,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    final message = json['message'];
    return DeleteAccountResponse(
      isSuccess: json['success'] == true,
      message: message is String ? message.trim() : '',
    );
  }
}
