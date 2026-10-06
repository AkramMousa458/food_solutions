import 'package:food_solutions/core/services/api_service.dart';
import 'package:food_solutions/core/utils/endpoint.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';

abstract class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> fetchAccount();

  Future<Map<String, dynamic>> createEstablishment(
    CreateEstablishmentRequest request,
  );

  Future<Map<String, dynamic>> updateEstablishment(
    int id,
    CreateEstablishmentRequest request,
  );

  Future<Map<String, dynamic>> deleteEstablishment(int id);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService _apiService;

  ProfileRemoteDataSourceImpl(this._apiService);

  @override
  Future<Map<String, dynamic>> fetchAccount() {
    return _apiService.get(endPoint: Endpoint.account);
  }

  @override
  Future<Map<String, dynamic>> createEstablishment(
    CreateEstablishmentRequest request,
  ) {
    return _apiService.post(
      endPoint: Endpoint.establishments,
      data: request.toJson(),
    );
  }

  @override
  Future<Map<String, dynamic>> updateEstablishment(
    int id,
    CreateEstablishmentRequest request,
  ) {
    return _apiService.update(
      endPoint: Endpoint.establishment(id),
      data: request.toJson(),
    );
  }

  @override
  Future<Map<String, dynamic>> deleteEstablishment(int id) {
    return _apiService.delete(endPoint: Endpoint.establishment(id));
  }
}
