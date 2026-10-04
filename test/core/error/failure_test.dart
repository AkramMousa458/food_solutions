import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';

void main() {
  test('maps http statuses to typed failures', () {
    final cases = <int, ApiFailureStatus>{
      400: ApiFailureStatus.badRequest,
      401: ApiFailureStatus.unauthorized,
      403: ApiFailureStatus.forbidden,
      404: ApiFailureStatus.notFound,
      408: ApiFailureStatus.requestTimeout,
      409: ApiFailureStatus.conflict,
      422: ApiFailureStatus.validation,
      429: ApiFailureStatus.tooManyRequests,
      500: ApiFailureStatus.server,
      502: ApiFailureStatus.server,
      503: ApiFailureStatus.server,
      418: ApiFailureStatus.badRequest,
    };
    for (final entry in cases.entries) {
      final actualFailure = ServerFailure.fromResponse(entry.key, null);
      expect(actualFailure.status, entry.value, reason: 'status ${entry.key}');
      expect(actualFailure.statusCode, entry.key);
      expect(actualFailure.message, _fallbackFor(entry.value));
    }
  });

  test('prefers the api message and then the first field error', () {
    final messageFailure = ServerFailure.fromResponse(409, <String, dynamic>{
      'success': false,
      'message': 'البريد مستخدم بالفعل',
    });
    expect(messageFailure.message, 'البريد مستخدم بالفعل');
    expect(messageFailure.status, ApiFailureStatus.conflict);
    final fieldFailure = ServerFailure.fromResponse(422, <String, dynamic>{
      'message': 'The given data was invalid.',
      'errors': <String, dynamic>{
        'identifier': <String>['The identifier field is required.'],
      },
    });
    expect(fieldFailure.message, 'The identifier field is required.');
    expect(fieldFailure.status, ApiFailureStatus.validation);
  });

  test('falls back when the api message is empty or too long', () {
    final emptyFailure = ServerFailure.fromResponse(500, <String, dynamic>{
      'message': '   ',
    });
    expect(emptyFailure.message, ApiErrorMessages.serverError);
    final longFailure = ServerFailure.fromResponse(400, <String, dynamic>{
      'message': 'x' * 301,
    });
    expect(longFailure.message, ApiErrorMessages.badRequest);
    expect(longFailure.status, ApiFailureStatus.badRequest);
  });

  test('maps transport failures', () {
    final timeout = ServerFailure.fromDioError(
      DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionTimeout,
      ),
    );
    expect(timeout.status, ApiFailureStatus.connectionTimeout);
    expect(timeout.message, ApiErrorMessages.connectionTimeout);
    final offline = ServerFailure.fromDioError(
      DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      ),
    );
    expect(offline.status, ApiFailureStatus.noInternet);
    expect(offline.message, ApiErrorMessages.noInternetConnection);
    final cancelled = ServerFailure.fromDioError(
      DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.cancel,
      ),
    );
    expect(cancelled.status, ApiFailureStatus.cancelled);
    final socket = ServerFailure.fromDioError(
      DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.unknown,
        message: 'SocketException: Failed host lookup',
      ),
    );
    expect(socket.status, ApiFailureStatus.noInternet);
  });
}

String _fallbackFor(ApiFailureStatus status) {
  switch (status) {
    case ApiFailureStatus.badRequest:
      return ApiErrorMessages.badRequest;
    case ApiFailureStatus.unauthorized:
      return ApiErrorMessages.unauthorized;
    case ApiFailureStatus.forbidden:
      return ApiErrorMessages.forbidden;
    case ApiFailureStatus.notFound:
      return ApiErrorMessages.notFound;
    case ApiFailureStatus.requestTimeout:
      return ApiErrorMessages.requestTimeout;
    case ApiFailureStatus.conflict:
      return ApiErrorMessages.conflict;
    case ApiFailureStatus.validation:
      return ApiErrorMessages.validationError;
    case ApiFailureStatus.tooManyRequests:
      return ApiErrorMessages.tooManyRequests;
    case ApiFailureStatus.server:
      return ApiErrorMessages.serverError;
    default:
      return ApiErrorMessages.unexpectedError;
  }
}
