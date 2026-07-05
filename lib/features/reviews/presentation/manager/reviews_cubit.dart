import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/features/services/data/models/service_item_model.dart';
import '../../data/repo/reviews_repo.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepo _repo;

  ReviewsCubit(this._repo) : super(ReviewsInitial());

  void loadReviews() {
    emit(ReviewsLoaded(reviewsByService: _repo.getAllServiceReviews()));
  }

  void seedServiceReviews(int serviceId, ServiceReviewsModel? reviews) {
    _repo.seedServiceReviews(serviceId, reviews);
    emit(ReviewsLoaded(reviewsByService: _repo.getAllServiceReviews()));
  }

  Future<void> submitReview({
    required int serviceId,
    required String name,
    required int rating,
    required String comment,
  }) async {
    final current = _repo.getAllServiceReviews();
    emit(ReviewsLoaded(reviewsByService: current, isSubmitting: true));

    try {
      await _repo.submitReview(
        serviceId: serviceId,
        name: name,
        rate: rating,
        comment: comment,
      );
      emit(ReviewsLoaded(reviewsByService: _repo.getAllServiceReviews()));
    } catch (e) {
      emit(ReviewsLoaded(reviewsByService: current));
      rethrow;
    }
  }
}
