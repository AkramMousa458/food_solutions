import 'package:food_solutions/core/error/failure.dart';

enum ApiFailureFeedback { warning, error, endSession, ignore }

ApiFailureFeedback feedbackForApiStatus(ApiFailureStatus status) {
  switch (status) {
    case ApiFailureStatus.validation:
    case ApiFailureStatus.badRequest:
    case ApiFailureStatus.conflict:
    case ApiFailureStatus.tooManyRequests:
    case ApiFailureStatus.noInternet:
    case ApiFailureStatus.connectionTimeout:
    case ApiFailureStatus.sendTimeout:
    case ApiFailureStatus.receiveTimeout:
    case ApiFailureStatus.requestTimeout:
      return ApiFailureFeedback.warning;
    case ApiFailureStatus.unauthorized:
      return ApiFailureFeedback.endSession;
    case ApiFailureStatus.cancelled:
      return ApiFailureFeedback.ignore;
    case ApiFailureStatus.badCertificate:
    case ApiFailureStatus.forbidden:
    case ApiFailureStatus.notFound:
    case ApiFailureStatus.server:
    case ApiFailureStatus.unsuccessful:
    case ApiFailureStatus.unexpected:
      return ApiFailureFeedback.error;
  }
}
