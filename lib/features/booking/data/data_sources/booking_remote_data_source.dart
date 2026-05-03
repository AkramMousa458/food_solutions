import 'package:food_solutions/core/services/api_service.dart';
import '../models/consultation_request_model.dart';

abstract class BookingRemoteDataSource {
  Future<Map<String, dynamic>> submitConsultation(
    ConsultationRequestModel model,
  );
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiService _apiService;

  BookingRemoteDataSourceImpl(this._apiService);

  @override
  Future<Map<String, dynamic>> submitConsultation(
    ConsultationRequestModel model,
  ) async {
    return _apiService.post(
      endPoint: '/api/consultation',
      data: model.toJson(),
    );
  }
}
