import 'package:food_solutions/core/services/api_service.dart';
import '../models/statistics_model.dart';

abstract class StatisticsRemoteDataSource {
  Future<StatisticsModel> getStatistics();
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  final ApiService _apiService;

  StatisticsRemoteDataSourceImpl(this._apiService);

  @override
  Future<StatisticsModel> getStatistics() async {
    final response = await _apiService.get(endPoint: '/api/statistics');
    final data = response['data'] as Map<String, dynamic>;
    return StatisticsModel.fromJson(data);
  }
}
