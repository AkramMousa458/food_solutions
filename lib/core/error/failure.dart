import 'package:dio/dio.dart';
import 'package:food_solutions/core/language/app_translations.dart';

const int _maxApiMessageLength = 300;

enum ApiFailureStatus {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  requestTimeout,
  badCertificate,
  cancelled,
  noInternet,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  tooManyRequests,
  server,
  unsuccessful,
  unexpected,
}

/// Constants for error messages with translation support
class ApiErrorMessages {
  static String get connectionTimeout => translate('connectionTimeout');
  static String get sendTimeout => translate('sendTimeout');
  static String get receiveTimeout => translate('receiveTimeout');
  static String get requestTimeout => translate('requestTimeout');
  static String get requestCancelled => translate('requestCancelled');
  static String get noInternetConnection => translate('no_internet');
  static String get unexpectedError => translate('unexpectedError');
  static String get serverError => translate('serverError');
  static String get notFound => translate('notFound');
  static String get unauthorized => translate('unauthorized');
  static String get forbidden => translate('forbidden');
  static String get badRequest => translate('badRequest');
  static String get validationError => translate('validationError');
  static String get conflict => translate('conflict');
  static String get tooManyRequests => translate('tooManyRequests');
  static String get badCertificate => translate('badCertificate');
}

/// Abstract base class representing API failures
abstract class ApiFailure {
  final String message;
  final int? statusCode;
  final Object? data;

  const ApiFailure({required this.message, this.statusCode, this.data});

  @override
  String toString() => 'ApiFailure(message: $message, statusCode: $statusCode)';
}

/// Represents server-related failures
class ServerFailure extends ApiFailure {
  final ApiFailureStatus status;

  const ServerFailure({
    required super.message,
    required this.status,
    super.statusCode,
    super.data,
  });

  /// Creates a [ServerFailure] from a [DioException]
  factory ServerFailure.fromDioError(DioException error) {
    if (error.type == DioExceptionType.badResponse) {
      return ServerFailure.fromResponse(
        error.response?.statusCode,
        error.response?.data,
      );
    }
    final status = _statusForDioType(error);
    return ServerFailure(message: _fallbackMessage(status), status: status);
  }

  /// Creates a [ServerFailure] from an HTTP response
  factory ServerFailure.fromResponse(int? statusCode, Object? response) {
    final body = _asStringMap(response);
    final status = _statusForCode(statusCode);
    return ServerFailure(
      message: _resolveMessage(body, status),
      status: status,
      statusCode: statusCode,
      data: body,
    );
  }
}

/// Extension methods for DioException
extension DioExceptionExtension on DioException {
  /// Converts a DioException to a ServerFailure
  ServerFailure toServerFailure() => ServerFailure.fromDioError(this);
}

ApiFailureStatus _statusForDioType(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return ApiFailureStatus.connectionTimeout;
    case DioExceptionType.sendTimeout:
      return ApiFailureStatus.sendTimeout;
    case DioExceptionType.receiveTimeout:
      return ApiFailureStatus.receiveTimeout;
    case DioExceptionType.badCertificate:
      return ApiFailureStatus.badCertificate;
    case DioExceptionType.cancel:
      return ApiFailureStatus.cancelled;
    case DioExceptionType.connectionError:
      return ApiFailureStatus.noInternet;
    case DioExceptionType.unknown:
      final message = error.message ?? '';
      if (message.contains('SocketException')) {
        return ApiFailureStatus.noInternet;
      }
      return ApiFailureStatus.unexpected;
    case DioExceptionType.badResponse:
      return ApiFailureStatus.unexpected;
  }
}

ApiFailureStatus _statusForCode(int? statusCode) {
  switch (statusCode) {
    case 400:
      return ApiFailureStatus.badRequest;
    case 401:
      return ApiFailureStatus.unauthorized;
    case 403:
      return ApiFailureStatus.forbidden;
    case 404:
      return ApiFailureStatus.notFound;
    case 408:
      return ApiFailureStatus.requestTimeout;
    case 409:
      return ApiFailureStatus.conflict;
    case 422:
      return ApiFailureStatus.validation;
    case 429:
      return ApiFailureStatus.tooManyRequests;
    default:
      if (statusCode != null && statusCode >= 500) {
        return ApiFailureStatus.server;
      }
      if (statusCode != null && statusCode >= 400) {
        return ApiFailureStatus.badRequest;
      }
      return ApiFailureStatus.unexpected;
  }
}

String _resolveMessage(Map<String, dynamic> body, ApiFailureStatus status) {
  final fieldError = _firstFieldError(body);
  if (fieldError != null) return _limitMessage(fieldError, status);
  final rawMessage = body['message'];
  if (rawMessage is String) return _limitMessage(rawMessage, status);
  return _fallbackMessage(status);
}

String? _firstFieldError(Map<String, dynamic> body) {
  final errors = body['errors'];
  if (errors is! Map || errors.isEmpty) return null;
  final firstValue = errors.values.first;
  if (firstValue is List && firstValue.isNotEmpty) {
    final firstError = firstValue.first;
    if (firstError is String && firstError.trim().isNotEmpty) {
      return firstError.trim();
    }
  }
  if (firstValue is String && firstValue.trim().isNotEmpty) {
    return firstValue.trim();
  }
  return null;
}

String _limitMessage(String message, ApiFailureStatus status) {
  final trimmed = message.trim();
  if (trimmed.isEmpty || trimmed.length > _maxApiMessageLength) {
    return _fallbackMessage(status);
  }
  return trimmed;
}

String _fallbackMessage(ApiFailureStatus status) {
  switch (status) {
    case ApiFailureStatus.connectionTimeout:
      return ApiErrorMessages.connectionTimeout;
    case ApiFailureStatus.sendTimeout:
      return ApiErrorMessages.sendTimeout;
    case ApiFailureStatus.receiveTimeout:
      return ApiErrorMessages.receiveTimeout;
    case ApiFailureStatus.requestTimeout:
      return ApiErrorMessages.requestTimeout;
    case ApiFailureStatus.badCertificate:
      return ApiErrorMessages.badCertificate;
    case ApiFailureStatus.cancelled:
      return ApiErrorMessages.requestCancelled;
    case ApiFailureStatus.noInternet:
      return ApiErrorMessages.noInternetConnection;
    case ApiFailureStatus.badRequest:
      return ApiErrorMessages.badRequest;
    case ApiFailureStatus.unauthorized:
      return ApiErrorMessages.unauthorized;
    case ApiFailureStatus.forbidden:
      return ApiErrorMessages.forbidden;
    case ApiFailureStatus.notFound:
      return ApiErrorMessages.notFound;
    case ApiFailureStatus.conflict:
      return ApiErrorMessages.conflict;
    case ApiFailureStatus.validation:
      return ApiErrorMessages.validationError;
    case ApiFailureStatus.tooManyRequests:
      return ApiErrorMessages.tooManyRequests;
    case ApiFailureStatus.server:
      return ApiErrorMessages.serverError;
    case ApiFailureStatus.unsuccessful:
    case ApiFailureStatus.unexpected:
      return ApiErrorMessages.unexpectedError;
  }
}

Map<String, dynamic> _asStringMap(Object? response) {
  if (response is Map<String, dynamic>) return response;
  if (response is Map) return Map<String, dynamic>.from(response);
  return <String, dynamic>{};
}
