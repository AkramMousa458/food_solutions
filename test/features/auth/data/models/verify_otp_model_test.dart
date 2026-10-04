import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';

void main() {
  test('builds the verify otp request body', () {
    const inputRequest = VerifyOtpRequestModel(
      identifier: 'mohmedetman955@gmail.com',
      code: '903575',
    );
    expect(inputRequest.toJson(), <String, dynamic>{
      'identifier': 'mohmedetman955@gmail.com',
      'code': '903575',
    });
  });

  test('parses a verified otp response with null user and token', () {
    final actualResult = VerifyOtpResponseModel.fromJson(<String, dynamic>{
      'success': true,
      'message': 'تم التحقق من الرمز بنجاح.',
      'verified': true,
      'user': null,
      'token': null,
    });
    expect(actualResult.isSuccess, isTrue);
    expect(actualResult.isVerified, isTrue);
    expect(actualResult.message, 'تم التحقق من الرمز بنجاح.');
    expect(actualResult.token, isNull);
  });
}
