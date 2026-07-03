import 'dart:convert';

import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import '../models/review_model.dart';

abstract class ReviewsLocalDataSource {
  List<ReviewModel> getAllReviews();
  List<ReviewModel> getReviewsForService(int serviceId);
  Future<void> addReview(ReviewModel review);
}

class ReviewsLocalDataSourceImpl implements ReviewsLocalDataSource {
  final LocalStorage _localStorage;

  ReviewsLocalDataSourceImpl(this._localStorage);

  List<ReviewModel> _parseReviews() {
    final jsonString = _localStorage.getString(AppConstants.reviewsKey);
    if (jsonString == null) return [];
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  List<ReviewModel> getAllReviews() => _parseReviews();

  @override
  List<ReviewModel> getReviewsForService(int serviceId) {
    return _parseReviews()
        .where((review) => review.serviceId == serviceId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> addReview(ReviewModel review) async {
    final reviews = _parseReviews()..add(review);
    final jsonString = jsonEncode(reviews.map((r) => r.toJson()).toList());
    await _localStorage.setString(AppConstants.reviewsKey, jsonString);
  }
}
