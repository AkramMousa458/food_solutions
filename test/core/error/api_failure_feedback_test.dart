import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/api_failure_feedback.dart';
import 'package:food_solutions/core/error/failure.dart';

void main() {
  test('maps every api status to feedback', () {
    final actualFeedback = {
      for (final status in ApiFailureStatus.values)
        status: feedbackForApiStatus(status),
    };
    expect(
      actualFeedback[ApiFailureStatus.validation],
      ApiFailureFeedback.warning,
    );
    expect(
      actualFeedback[ApiFailureStatus.badRequest],
      ApiFailureFeedback.warning,
    );
    expect(
      actualFeedback[ApiFailureStatus.noInternet],
      ApiFailureFeedback.warning,
    );
    expect(
      actualFeedback[ApiFailureStatus.tooManyRequests],
      ApiFailureFeedback.warning,
    );
    expect(
      actualFeedback[ApiFailureStatus.unauthorized],
      ApiFailureFeedback.endSession,
    );
    expect(
      actualFeedback[ApiFailureStatus.cancelled],
      ApiFailureFeedback.ignore,
    );
    expect(actualFeedback[ApiFailureStatus.server], ApiFailureFeedback.error);
    expect(
      actualFeedback[ApiFailureStatus.forbidden],
      ApiFailureFeedback.error,
    );
    expect(actualFeedback.length, ApiFailureStatus.values.length);
  });
}
