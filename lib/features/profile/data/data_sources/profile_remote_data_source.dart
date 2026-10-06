import 'package:food_solutions/core/services/api_service.dart';
import 'package:food_solutions/core/utils/endpoint.dart';

abstract class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> fetchAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService _apiService;

  ProfileRemoteDataSourceImpl(this._apiService);

  @override
  Future<Map<String, dynamic>> fetchAccount() {
    return _apiService.get(endPoint: Endpoint.account);
  }
}
