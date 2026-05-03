import 'package:food_solutions/core/services/api_service.dart';
import '../models/home_section_model.dart';

abstract class HomeSectionsRemoteDataSource {
  Future<List<HomeSectionModel>> getHomeSections();
}

class HomeSectionsRemoteDataSourceImpl implements HomeSectionsRemoteDataSource {
  final ApiService _apiService;

  HomeSectionsRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<HomeSectionModel>> getHomeSections() async {
    final response = await _apiService.get(endPoint: '/api/home');
    final data = response['data'] as List<dynamic>;
    return data
        .map((item) => HomeSectionModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
