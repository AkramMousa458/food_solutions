import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/utils/endpoint.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_session_data_source.dart';
import 'package:food_solutions/features/auth/data/models/login_request_model.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/auth/data/models/register_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo_impl.dart';

void main() {
  const inputRequest = SendOtpRequestModel(
    identifier: 'akrammousa458@gmail.com',
  );

  test('returns the otp payload when success is true', () async {
    final mockDataSource = _MockAuthRemoteDataSource(
      response: <String, dynamic>{
        'success': true,
        'message': 'تم إرسال رمز التحقق إلى بريدك الإلكتروني (Gmail) بنجاح.',
        'identifier': 'akrammousa458@gmail.com',
        'type': 'email',
        'expires_at': '2026-10-04T22:28:50+00:00',
        'code': '510098',
      },
    );
    final repo = AuthRepoImpl(mockDataSource);
    final actualResult = await repo.sendOtp(inputRequest);
    expect(mockDataSource.lastRequest?.identifier, inputRequest.identifier);
    expect(mockDataSource.lastRequest?.type, inputRequest.type);
    expect(actualResult.isRight(), isTrue);
    final response = actualResult.getOrElse(
      () => throw StateError('expected success'),
    );
    expect(response.identifier, 'akrammousa458@gmail.com');
    expect(response.type, SendOtpRequestModel.emailType);
    expect(response.code, '510098');
  });

  test('returns unsuccessful when the body success flag is false', () async {
    const inputMessage = 'تعذر إرسال رمز التحقق.';
    final mockDataSource = _MockAuthRemoteDataSource(
      response: <String, dynamic>{'success': false, 'message': inputMessage},
    );
    final repo = AuthRepoImpl(mockDataSource);
    final actualResult = await repo.sendOtp(inputRequest);
    final expectedFailure = ServerFailure(
      message: inputMessage,
      status: ApiFailureStatus.unsuccessful,
      data: <String, dynamic>{'success': false, 'message': inputMessage},
    );
    expect(actualResult.isLeft(), isTrue);
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.message, expectedFailure.message);
    expect(actualFailure.status, expectedFailure.status);
  });

  test('maps dio status codes through server failure', () async {
    final requestOptions = RequestOptions(path: Endpoint.sendOtp);
    final mockDataSource = _MockAuthRemoteDataSource(
      error: DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response<Map<String, dynamic>>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: <String, dynamic>{
            'message': 'The given data was invalid.',
            'errors': <String, dynamic>{
              'identifier': <String>['The identifier field is required.'],
            },
          },
        ),
      ),
    );
    final repo = AuthRepoImpl(mockDataSource);
    final actualResult = await repo.sendOtp(inputRequest);
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.status, ApiFailureStatus.validation);
    expect(actualFailure.statusCode, 422);
    expect(actualFailure.message, 'The identifier field is required.');
  });

  test('maps unexpected errors to a failure', () async {
    final mockDataSource = _MockAuthRemoteDataSource(
      error: Exception('broken'),
    );
    final repo = AuthRepoImpl(mockDataSource);
    final actualResult = await repo.sendOtp(inputRequest);
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.status, ApiFailureStatus.unexpected);
    expect(actualFailure.message, ApiErrorMessages.unexpectedError);
  });

  test('returns a verified otp result', () async {
    const inputVerifyRequest = VerifyOtpRequestModel(
      identifier: 'mohmedetman955@gmail.com',
      code: '903575',
    );
    final mockDataSource = _MockAuthRemoteDataSource(
      response: <String, dynamic>{
        'success': true,
        'message': 'تم التحقق من الرمز بنجاح.',
        'verified': true,
        'user': null,
        'token': null,
      },
    );
    final repo = AuthRepoImpl(mockDataSource);
    final actualResult = await repo.verifyOtp(inputVerifyRequest);
    final response = actualResult.getOrElse(
      () => throw StateError('expected success'),
    );
    expect(
      mockDataSource.lastVerifyRequest?.identifier,
      inputVerifyRequest.identifier,
    );
    expect(mockDataSource.lastVerifyRequest?.code, inputVerifyRequest.code);
    expect(response.isSuccess, isTrue);
    expect(response.isVerified, isTrue);
    expect(response.message, 'تم التحقق من الرمز بنجاح.');
    expect(response.user, isNull);
    expect(response.token, isNull);
  });

  test('maps an invalid otp response to the field error', () async {
    const inputMessage = 'رمز التحقق غير صحيح أو منتهي الصلاحية.';
    final requestOptions = RequestOptions(path: Endpoint.verifyOtp);
    final mockDataSource = _MockAuthRemoteDataSource(
      error: DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response<Map<String, dynamic>>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: <String, dynamic>{
            'message': inputMessage,
            'errors': <String, dynamic>{
              'code': <String>[inputMessage],
            },
          },
        ),
      ),
    );
    final repo = AuthRepoImpl(mockDataSource);
    final actualResult = await repo.verifyOtp(
      const VerifyOtpRequestModel(
        identifier: 'mohmedetman955@gmail.com',
        code: '000000',
      ),
    );
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.status, ApiFailureStatus.validation);
    expect(actualFailure.statusCode, 422);
    expect(actualFailure.message, inputMessage);
  });

  test('treats a successful body that is not verified as a failure', () async {
    const inputMessage = 'لم يتم التحقق.';
    final mockDataSource = _MockAuthRemoteDataSource(
      response: <String, dynamic>{
        'success': true,
        'message': inputMessage,
        'verified': false,
        'user': null,
        'token': null,
      },
    );
    final repo = AuthRepoImpl(mockDataSource);
    final actualResult = await repo.verifyOtp(
      const VerifyOtpRequestModel(
        identifier: 'mohmedetman955@gmail.com',
        code: '903575',
      ),
    );
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.status, ApiFailureStatus.unsuccessful);
    expect(actualFailure.message, inputMessage);
  });

  test('saves the session when login succeeds', () async {
    const inputLogin = LoginRequestModel(
      emailOrPhone: 'akrammousa458@gmail.com',
      password: '12345678',
    );
    final mockDataSource = _MockAuthRemoteDataSource(
      response: <String, dynamic>{
        'token': '8|9Z3c13rJTaai6BzvYxkSOrHq6eK7F3yQ5uJY2XtX7194eec8',
        'user': <String, dynamic>{
          'id': 5,
          'name': 'Akram Mousa',
          'email': 'akrammousa458@gmail.com',
          'phone': '01097066403',
          'email_verified_at': '2026-10-04T23:22:44.000000Z',
          'phone_verified_at': null,
          'role': 'admin',
          'created_at': '2026-10-04T23:21:48.000000Z',
          'updated_at': '2026-10-04T23:27:53.000000Z',
          'establishments': <Object>[],
        },
      },
    );
    final mockSession = _RecordingAuthSession();
    final repo = AuthRepoImpl(mockDataSource, sessionDataSource: mockSession);
    final actualResult = await repo.login(inputLogin);
    final session = actualResult.getOrElse(
      () => throw StateError('expected success'),
    );
    expect(
      mockDataSource.lastLoginRequest?.emailOrPhone,
      inputLogin.emailOrPhone,
    );
    expect(mockDataSource.lastLoginRequest?.password, inputLogin.password);
    expect(session.token, '8|9Z3c13rJTaai6BzvYxkSOrHq6eK7F3yQ5uJY2XtX7194eec8');
    expect(session.user.id, 5);
    expect(session.user.name, 'Akram Mousa');
    expect(session.user.email, 'akrammousa458@gmail.com');
    expect(session.user.phone, '01097066403');
    expect(session.user.role, 'admin');
    expect(session.user.phoneVerifiedAt, isNull);
    expect(session.user.establishments, isEmpty);
    expect(mockSession.saved?.token, session.token);
    expect(repo.hasAuthToken(), isTrue);
  });

  test('maps invalid login credentials to the field error', () async {
    const inputMessage = 'بيانات الدخول غير صحيحة.';
    final requestOptions = RequestOptions(path: Endpoint.login);
    final mockDataSource = _MockAuthRemoteDataSource(
      error: DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response<Map<String, dynamic>>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: <String, dynamic>{
            'message': inputMessage,
            'errors': <String, dynamic>{
              'email_or_phone': <String>[inputMessage],
            },
          },
        ),
      ),
    );
    final mockSession = _RecordingAuthSession();
    final repo = AuthRepoImpl(mockDataSource, sessionDataSource: mockSession);
    final actualResult = await repo.login(
      const LoginRequestModel(
        emailOrPhone: 'akrammousa458@gmail.com',
        password: '12345678',
      ),
    );
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.message, inputMessage);
    expect(actualFailure.status, ApiFailureStatus.validation);
    expect(actualFailure.statusCode, 422);
    expect(mockSession.saved, isNull);
  });

  test('returns the created account when registration succeeds', () async {
    const inputRegister = RegisterRequestModel(
      name: 'Akram Mousa',
      phone: '01097066405',
      email: 'akramyanas458@gmail.com',
      password: '12345678',
      passwordConfirmation: '12345678',
    );
    const inputMessage =
        'تم إنشاء الحساب بنجاح. يرجى تفعيل الحساب باستخدام رمز التحقق (OTP) المرسل إليك.';
    final mockDataSource = _MockAuthRemoteDataSource(
      response: <String, dynamic>{
        'success': true,
        'message': inputMessage,
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
      },
    );
    final repo = AuthRepoImpl(mockDataSource);
    final actualResult = await repo.register(inputRegister);
    final account = actualResult.getOrElse(
      () => throw StateError('expected success'),
    );
    expect(mockDataSource.lastRegisterRequest?.name, inputRegister.name);
    expect(mockDataSource.lastRegisterRequest?.phone, inputRegister.phone);
    expect(mockDataSource.lastRegisterRequest?.email, inputRegister.email);
    expect(
      mockDataSource.lastRegisterRequest?.password,
      inputRegister.password,
    );
    expect(
      mockDataSource.lastRegisterRequest?.passwordConfirmation,
      inputRegister.passwordConfirmation,
    );
    expect(account.isSuccess, isTrue);
    expect(account.requiresVerification, isTrue);
    expect(account.identifier, 'akramyanas458@gmail.com');
    expect(account.message, inputMessage);
    expect(account.user?.id, 7);
    expect(account.user?.name, 'Akram Mousa');
    expect(account.user?.phone, '01097066405');
    expect(account.user?.role, 'client');
  });

  test('treats a failed registration body as a failure', () async {
    const inputMessage = 'البريد الإلكتروني مستخدم بالفعل.';
    final mockDataSource = _MockAuthRemoteDataSource(
      response: <String, dynamic>{
        'success': false,
        'message': inputMessage,
        'requires_verification': false,
        'identifier': '',
        'user': null,
      },
    );
    final repo = AuthRepoImpl(mockDataSource);
    final actualResult = await repo.register(
      const RegisterRequestModel(
        name: 'Akram Mousa',
        phone: '01097066405',
        email: 'akramyanas458@gmail.com',
        password: '12345678',
        passwordConfirmation: '12345678',
      ),
    );
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.status, ApiFailureStatus.unsuccessful);
    expect(actualFailure.message, inputMessage);
  });
}

class _MockAuthRemoteDataSource implements AuthRemoteDataSource {
  final Map<String, dynamic>? response;
  final Object? error;
  SendOtpRequestModel? lastRequest;
  VerifyOtpRequestModel? lastVerifyRequest;
  LoginRequestModel? lastLoginRequest;
  RegisterRequestModel? lastRegisterRequest;

  _MockAuthRemoteDataSource({this.response, this.error});

  @override
  Future<Map<String, dynamic>> sendOtp(SendOtpRequestModel request) async {
    lastRequest = request;
    final thrown = error;
    if (thrown != null) throw thrown;
    return response!;
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(VerifyOtpRequestModel request) async {
    lastVerifyRequest = request;
    final thrown = error;
    if (thrown != null) throw thrown;
    return response!;
  }

  @override
  Future<Map<String, dynamic>> login(LoginRequestModel request) async {
    lastLoginRequest = request;
    final thrown = error;
    if (thrown != null) throw thrown;
    return response!;
  }

  @override
  Future<Map<String, dynamic>> register(RegisterRequestModel request) async {
    lastRegisterRequest = request;
    final thrown = error;
    if (thrown != null) throw thrown;
    return response!;
  }
}

class _RecordingAuthSession implements AuthSessionDataSource {
  LoginResponseModel? saved;

  @override
  Future<void> saveSession(LoginResponseModel session) async {
    saved = session;
  }

  @override
  String? readToken() {
    final token = saved?.token;
    if (token == null || token.isEmpty) return null;
    return token;
  }

  @override
  Future<void> clearSession() async {
    saved = null;
  }
}
