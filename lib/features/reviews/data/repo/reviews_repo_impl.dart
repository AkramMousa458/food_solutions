import 'package:food_solutions/features/services/data/models/service_item_model.dart';
import '../data_sources/reviews_remote_data_source.dart';
import '../models/review_model.dart';
import 'reviews_repo.dart';

class ReviewsRepoImpl implements ReviewsRepo {
  final ReviewsRemoteDataSource _remoteDataSource;
  final Map<int, ServiceReviewsEntry> _reviewsByService = {};

  ReviewsRepoImpl(this._remoteDataSource);

  @override
  Map<int, ServiceReviewsEntry> getAllServiceReviews() =>
      Map.unmodifiable(_reviewsByService);

  @override
  ServiceReviewsEntry getServiceReviews(int serviceId) {
    return _reviewsByService[serviceId] ?? ServiceReviewsEntry.empty;
  }

  @override
  void seedServiceReviews(int serviceId, ServiceReviewsModel? reviews) {
    if (reviews == null) {
      _reviewsByService[serviceId] = ServiceReviewsEntry.empty;
      return;
    }

    _reviewsByService[serviceId] = ServiceReviewsEntry(
      total: reviews.total,
      averageRate: reviews.averageRate,
      reviews: reviews.reviews
          .map(
            (item) => ReviewModel.fromServiceReviewItem(
              serviceId: serviceId,
              item: item,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<ReviewModel> submitReview({
    required int serviceId,
    required String name,
    required int rate,
    required String comment,
  }) async {
    final review = await _remoteDataSource.submitReview(
      serviceId: serviceId,
      name: name,
      comment: comment,
      rate: rate,
    );

    final current = getServiceReviews(serviceId);
    final updatedReviews = [...current.reviews, review];
    final newTotal = current.total + 1;
    final newAverage = updatedReviews.fold<double>(
          0,
          (sum, item) => sum + item.rate,
        ) /
        updatedReviews.length;

    _reviewsByService[serviceId] = ServiceReviewsEntry(
      total: newTotal,
      averageRate: newAverage,
      reviews: updatedReviews,
    );

    return review;
  }
}
