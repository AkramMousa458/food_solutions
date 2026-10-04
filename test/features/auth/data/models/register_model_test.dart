import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/auth/data/models/register_request_model.dart';
import 'package:food_solutions/features/auth/data/models/register_response_model.dart';

void main() {
  test('builds the register request body', () {
    const inputRequest = RegisterRequestModel(
      name: 'Akram Mousa',
      phone: '01097066405',
      email: 'akramyanas458@gmail.com',
      password: '12345678',
      passwordConfirmation: '12345678',
    );
    expect(inputRequest.toJson(), <String, dynamic>{
      'name': 'Akram Mousa',
      'phone': '01097066405',
      'email': 'akramyanas458@gmail.com',
      'password': '12345678',
      'password_confirmation': '12345678',
    });
  });

  test('parses a created account that still needs verification', () {
    final actualResult = RegisterResponseModel.fromJson(<String, dynamic>{
      'success': true,
      'message':
          'تم إنشاء الحساب بنجاح. يرجى تفعيل الحساب باستخدام رمز التحقق (OTP) المرسل إليك.',
      'requires_verification': true,
      'identifier': 'akramyanas458@gmail.com',
      'user': <String, dynamic>{
        'name': 'Akram Mousa',
        'phone': '01097066405',
        'email': 'akramyanas458@gmail.com',
        'role': 'client',
        'updated_at': '2026-10-04T23:30:28.000000Z',
        'created_at': '2026-10-04T23:30:28.000000Z',
        'id': 7,
      },
    });
    expect(actualResult.isSuccess, isTrue);
    expect(actualResult.requiresVerification, isTrue);
    expect(actualResult.identifier, 'akramyanas458@gmail.com');
    expect(actualResult.user?.id, 7);
    expect(actualResult.user?.email, 'akramyanas458@gmail.com');
    expect(
      actualResult.user?.createdAt,
      DateTime.parse('2026-10-04T23:30:28.000000Z'),
    );
  });
}
