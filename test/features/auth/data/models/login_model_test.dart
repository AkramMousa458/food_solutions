import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/auth/data/models/auth_user_model.dart';
import 'package:food_solutions/features/auth/data/models/login_request_model.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';

void main() {
  test('builds the login request body', () {
    const inputRequest = LoginRequestModel(
      emailOrPhone: 'akrammousa458@gmail.com',
      password: '12345678',
    );
    expect(inputRequest.toJson(), <String, dynamic>{
      'email_or_phone': 'akrammousa458@gmail.com',
      'password': '12345678',
    });
  });

  test('parses the login user and token', () {
    final actualResult = LoginResponseModel.fromJson(<String, dynamic>{
      'token': '4|session-token',
      'user': <String, dynamic>{
        'id': 4,
        'name': 'محمد أحمد',
        'email': 'mohmedetman955@gmail.com',
        'phone': '0101255874141',
        'email_verified_at': '2026-09-30T23:36:10.000000Z',
        'phone_verified_at': null,
        'role': 'client',
        'created_at': '2026-09-30T23:35:34.000000Z',
        'updated_at': '2026-09-30T23:36:10.000000Z',
        'establishments': <Object>[],
      },
    });
    expect(actualResult.token, '4|session-token');
    expect(actualResult.user, isA<AuthUserModel>());
    expect(actualResult.user.phoneVerifiedAt, isNull);
    expect(
      actualResult.user.emailVerifiedAt,
      DateTime.parse('2026-09-30T23:36:10.000000Z'),
    );
    expect(actualResult.user.establishments, isEmpty);
  });
}
