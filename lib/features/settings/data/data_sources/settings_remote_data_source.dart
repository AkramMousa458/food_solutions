import 'package:food_solutions/core/services/api_service.dart';
import 'package:food_solutions/core/utils/endpoint.dart';

abstract class SettingsRemoteDataSource {
  Future<Map<String, dynamic>> deleteAccount();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiService _apiService;

  SettingsRemoteDataSourceImpl(this._apiService);

  @override
  Future<Map<String, dynamic>> deleteAccount() {
    return _apiService.delete(endPoint: Endpoint.account);
  }
}
