import 'package:food_solutions/features/services/data/models/service_item_model.dart';
import '../models/review_model.dart';

class ServiceReviewsEntry {
  final int total;
  final double averageRate;
  final List<ReviewModel> reviews;

  const ServiceReviewsEntry({
    required this.total,
    required this.averageRate,
    required this.reviews,
  });

  static const empty = ServiceReviewsEntry(
    total: 0,
    averageRate: 0,
    reviews: [],
  );
}

abstract class ReviewsRepo {
  Map<int, ServiceReviewsEntry> getAllServiceReviews();
  ServiceReviewsEntry getServiceReviews(int serviceId);
  void seedServiceReviews(int serviceId, ServiceReviewsModel? reviews);
  Future<ReviewModel> submitReview({
    required int serviceId,
    required String name,
    required int rate,
    required String comment,
  });
}
