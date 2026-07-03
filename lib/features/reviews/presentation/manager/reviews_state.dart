import 'package:equatable/equatable.dart';
import '../../data/models/review_model.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<ReviewModel> allReviews;
  final bool isSubmitting;

  const ReviewsLoaded({required this.allReviews, this.isSubmitting = false});

  List<ReviewModel> reviewsForService(int serviceId) {
    return allReviews
        .where((r) => r.serviceId == serviceId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  double averageRating(int serviceId) {
    final reviews = reviewsForService(serviceId);
    if (reviews.isEmpty) return 0;
    return reviews.fold<int>(0, (sum, r) => sum + r.rating) / reviews.length;
  }

  int reviewCount(int serviceId) => reviewsForService(serviceId).length;

  @override
  List<Object?> get props => [allReviews, isSubmitting];
}

class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError(this.message);

  @override
  List<Object?> get props => [message];
}
