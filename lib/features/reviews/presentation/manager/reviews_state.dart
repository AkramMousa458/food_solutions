import 'package:equatable/equatable.dart';
import '../../data/models/review_model.dart';
import '../../data/repo/reviews_repo.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final Map<int, ServiceReviewsEntry> reviewsByService;
  final bool isSubmitting;

  const ReviewsLoaded({
    required this.reviewsByService,
    this.isSubmitting = false,
  });

  ServiceReviewsEntry _entryFor(int serviceId) {
    return reviewsByService[serviceId] ?? ServiceReviewsEntry.empty;
  }

  List<ReviewModel> reviewsForService(int serviceId) {
    return _entryFor(serviceId).reviews;
  }

  double averageRating(int serviceId) {
    return _entryFor(serviceId).averageRate;
  }

  int reviewCount(int serviceId) {
    return _entryFor(serviceId).total;
  }

  @override
  List<Object?> get props => [reviewsByService, isSubmitting];
}

class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
