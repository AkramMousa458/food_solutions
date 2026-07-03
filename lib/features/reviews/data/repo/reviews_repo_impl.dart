import '../data_sources/reviews_local_data_source.dart';
import '../models/review_model.dart';
import 'reviews_repo.dart';

class ReviewsRepoImpl implements ReviewsRepo {
  final ReviewsLocalDataSource _localDataSource;

  ReviewsRepoImpl(this._localDataSource);

  @override
  List<ReviewModel> getAllReviews() => _localDataSource.getAllReviews();

  @override
  List<ReviewModel> getReviewsForService(int serviceId) =>
      _localDataSource.getReviewsForService(serviceId);

  @override
  Future<void> submitReview({
    required int serviceId,
    required String userName,
    required int rating,
    required String comment,
  }) async {
    final review = ReviewModel(
      id: '${DateTime.now().microsecondsSinceEpoch}_$serviceId',
      serviceId: serviceId,
      userName: userName,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    await _localDataSource.addReview(review);
  }

  @override
  double getAverageRating(int serviceId) {
    final reviews = getReviewsForService(serviceId);
    if (reviews.isEmpty) return 0;
    final total = reviews.fold<int>(0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  @override
  int getReviewCount(int serviceId) => getReviewsForService(serviceId).length;
}
