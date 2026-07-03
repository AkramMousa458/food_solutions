import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/reviews_repo.dart';
import 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepo _repo;

  ReviewsCubit(this._repo) : super(ReviewsInitial());

  void loadReviews() {
    try {
      emit(ReviewsLoaded(allReviews: _repo.getAllReviews()));
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }

  Future<void> submitReview({
    required int serviceId,
    required String userName,
    required int rating,
    required String comment,
  }) async {
    final current = state is ReviewsLoaded
        ? (state as ReviewsLoaded).allReviews
        : _repo.getAllReviews();
    emit(ReviewsLoaded(allReviews: current, isSubmitting: true));
    try {
      await _repo.submitReview(
        serviceId: serviceId,
        userName: userName,
        rating: rating,
        comment: comment,
      );
      emit(ReviewsLoaded(allReviews: _repo.getAllReviews()));
    } catch (e) {
      emit(ReviewsError(e.toString()));
      loadReviews();
    }
  }

  double getAverageRating(int serviceId) => _repo.getAverageRating(serviceId);

  int getReviewCount(int serviceId) => _repo.getReviewCount(serviceId);
}
