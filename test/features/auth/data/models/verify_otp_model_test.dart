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

  test('parses a verified otp response with the user and token', () {
    final actualResult = VerifyOtpResponseModel.fromJson(<String, dynamic>{
      'success': true,
      'message': 'تم التحقق من الرمز بنجاح.',
      'verified': true,
      'user': <String, dynamic>{
        'id': 5,
        'name': 'Akram Mousa',
        'email': 'akrammousa458@gmail.com',
        'phone': '01097066403',
        'email_verified_at': '2026-10-04T23:22:44.000000Z',
        'phone_verified_at': null,
        'role': 'client',
        'created_at': '2026-10-04T23:21:48.000000Z',
        'updated_at': '2026-10-04T23:22:44.000000Z',
      },
      'token': '5|2MCDoYyoqjTh8vhlJGXiIRyNdqpJAxBqfAMgIQ5qd7634872',
    });
    expect(actualResult.isSuccess, isTrue);
    expect(actualResult.isVerified, isTrue);
    expect(actualResult.message, 'تم التحقق من الرمز بنجاح.');
    expect(actualResult.user?.id, 5);
    expect(actualResult.user?.name, 'Akram Mousa');
    expect(actualResult.user?.email, 'akrammousa458@gmail.com');
    expect(actualResult.user?.phone, '01097066403');
    expect(actualResult.user?.role, 'client');
    expect(actualResult.user?.phoneVerifiedAt, isNull);
    expect(
      actualResult.user?.emailVerifiedAt,
      DateTime.parse('2026-10-04T23:22:44.000000Z'),
    );
    expect(
      actualResult.token,
      '5|2MCDoYyoqjTh8vhlJGXiIRyNdqpJAxBqfAMgIQ5qd7634872',
    );
  });

  test('keeps user and token empty when the api omits them', () {
    final actualResult = VerifyOtpResponseModel.fromJson(<String, dynamic>{
      'success': true,
      'message': 'تم التحقق من الرمز بنجاح.',
      'verified': true,
      'user': null,
      'token': null,
    });
    expect(actualResult.user, isNull);
    expect(actualResult.token, isNull);
  });
}
