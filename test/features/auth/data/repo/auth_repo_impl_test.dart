import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_session_data_source.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo_impl.dart';

void main() {
  const inputPhone = '966501234567';
  const inputCode = '123456';

  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthSessionDataSource mockSessionDataSource;
  late AuthRepoImpl repo;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockSessionDataSource = MockAuthSessionDataSource();
    repo = AuthRepoImpl(
      mockRemoteDataSource,
      sessionDataSource: mockSessionDataSource,
    );
  });

  test(
    'verifyOtp saves the session when the response includes a token',
    () async {
      mockRemoteDataSource.verifyResponse = {
        'success': true,
        'verified': true,
        'message': 'ok',
        'token': 'token-1',
        'user': {
          'id': 7,
          'name': 'Noura',
          'email': 'noura@example.com',
          'phone': inputPhone,
          'role': 'user',
          'establishments': [],
        },
      };
      final result = await repo.verifyOtp(
        const VerifyOtpRequestModel(identifier: inputPhone, code: inputCode),
      );
      final actualSession = mockSessionDataSource.savedSession;
      expect(result.isRight(), isTrue);
      expect(actualSession?.token, 'token-1');
      expect(actualSession?.user.id, 7);
      expect(actualSession?.user.phone, inputPhone);
    },
  );

  test('verifyOtp stores a stub user when the token has no user', () async {
    mockRemoteDataSource.verifyResponse = {
      'success': true,
      'verified': true,
      'message': 'ok',
      'token': 'token-2',
    };
    final result = await repo.verifyOtp(
      const VerifyOtpRequestModel(identifier: inputPhone, code: inputCode),
    );
    final actualUser = mockSessionDataSource.savedSession?.user;
    expect(result.isRight(), isTrue);
    expect(mockSessionDataSource.savedSession?.token, 'token-2');
    expect(actualUser?.id, 0);
    expect(actualUser?.name, '');
    expect(actualUser?.email, '');
    expect(actualUser?.phone, inputPhone);
  });

  test(
    'verifyOtp signs in with the phone when the code is verified without a token',
    () async {
      mockRemoteDataSource.verifyResponse = {
        'success': true,
        'verified': true,
        'message': 'تم التحقق من الرمز بنجاح.',
        'user': null,
        'token': null,
      };
      final result = await repo.verifyOtp(
        const VerifyOtpRequestModel(identifier: inputPhone, code: inputCode),
      );
      final actualSession = mockSessionDataSource.savedSession;
      expect(result.isRight(), isTrue);
      expect(actualSession?.token, isEmpty);
      expect(actualSession?.user.phone, inputPhone);
      expect(actualSession?.user.phoneVerifiedAt, isNotNull);
    },
  );
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  Map<String, dynamic> verifyResponse = {};

  @override
  Future<Map<String, dynamic>> sendOtp(SendOtpRequestModel request) async {
    return {'success': true};
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(VerifyOtpRequestModel request) async {
    return verifyResponse;
  }
}

class MockAuthSessionDataSource implements AuthSessionDataSource {
  LoginResponseModel? savedSession;

  @override
  Future<void> saveSession(LoginResponseModel session) async {
    savedSession = session;
  }

  @override
  String? readToken() => savedSession?.token;

  @override
  bool hasPhoneSession() => false;

  @override
  Future<void> clearSession() async {}

  @override
  Future<void> enterGuestMode() async {}

  @override
  bool isGuest() => false;
}
