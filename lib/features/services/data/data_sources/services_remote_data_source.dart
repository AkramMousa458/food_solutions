import 'package:food_solutions/core/services/api_service.dart';
import '../models/service_item_model.dart';

abstract class ServicesRemoteDataSource {
  Future<List<ServiceItemModel>> fetchServices();
}

class ServicesRemoteDataSourceImpl implements ServicesRemoteDataSource {
  final ApiService _apiService;

  ServicesRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<ServiceItemModel>> fetchServices() async {
    final response = await _apiService.get(endPoint: '/api/services');
    final dataList = response['data'] as List<dynamic>;
    return dataList
        .map((json) => ServiceItemModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
