import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';

void main() {
  test('parses a successful send otp response', () {
    final inputJson = <String, dynamic>{
      'success': true,
      'message': 'تم إرسال رمز التحقق إلى بريدك الإلكتروني (Gmail) بنجاح.',
      'identifier': 'akrammousa458@gmail.com',
      'type': 'email',
      'expires_at': '2026-10-04T22:28:50+00:00',
      'code': '510098',
    };
    final actualResult = SendOtpResponseModel.fromJson(inputJson);
    expect(actualResult.isSuccess, isTrue);
    expect(
      actualResult.message,
      'تم إرسال رمز التحقق إلى بريدك الإلكتروني (Gmail) بنجاح.',
    );
    expect(actualResult.identifier, 'akrammousa458@gmail.com');
    expect(actualResult.type, 'email');
    expect(actualResult.expiresAt, DateTime.parse('2026-10-04T22:28:50+00:00'));
    expect(actualResult.code, '510098');
  });

  test('reads a numeric verification code', () {
    final actualResult = SendOtpResponseModel.fromJson(<String, dynamic>{
      'success': false,
      'code': 510098,
    });
    expect(actualResult.isSuccess, isFalse);
    expect(actualResult.code, '510098');
    expect(actualResult.message, isEmpty);
  });

  test('builds the send otp request body', () {
    const inputRequest = SendOtpRequestModel(
      identifier: 'akrammousa458@gmail.com',
    );
    final actualJson = inputRequest.toJson();
    expect(actualJson, <String, dynamic>{
      'identifier': 'akrammousa458@gmail.com',
      'type': 'email',
    });
  });
}
