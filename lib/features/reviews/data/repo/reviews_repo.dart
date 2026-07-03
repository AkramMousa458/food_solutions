import '../models/review_model.dart';

abstract class ReviewsRepo {
  List<ReviewModel> getAllReviews();
  List<ReviewModel> getReviewsForService(int serviceId);
  Future<void> submitReview({
    required int serviceId,
    required String userName,
    required int rating,
    required String comment,
  });
  double getAverageRating(int serviceId);
  int getReviewCount(int serviceId);
}
