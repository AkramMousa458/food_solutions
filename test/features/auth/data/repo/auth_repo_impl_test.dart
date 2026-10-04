import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/utils/endpoint.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_remote_data_source.dart';
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
}

class _MockAuthRemoteDataSource implements AuthRemoteDataSource {
  final Map<String, dynamic>? response;
  final Object? error;
  SendOtpRequestModel? lastRequest;
  VerifyOtpRequestModel? lastVerifyRequest;

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
}
