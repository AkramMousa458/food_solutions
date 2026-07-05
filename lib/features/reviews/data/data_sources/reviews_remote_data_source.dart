import 'package:dio/dio.dart';
import 'package:food_solutions/core/services/api_service.dart';
import '../models/review_model.dart';

abstract class ReviewsRemoteDataSource {
  Future<ReviewModel> submitReview({
    required int serviceId,
    required String name,
    required String comment,
    required int rate,
  });
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final ApiService _apiService;

  ReviewsRemoteDataSourceImpl(this._apiService);

  @override
  Future<ReviewModel> submitReview({
    required int serviceId,
    required String name,
    required String comment,
    required int rate,
  }) async {
    try {
      final response = await _apiService.post(
        endPoint: '/api/services/reviews',
        data: {
          'service_id': serviceId,
          'name': name,
          'comment': comment,
          'rate': rate,
        },
      );

      if (response['success'] != true) {
        throw Exception(
          response['message'] as String? ?? 'Failed to submit review',
        );
      }

      return ReviewModel.fromJson(response['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw Exception(data['message'] as String);
      }
      rethrow;
    }
  }
}
