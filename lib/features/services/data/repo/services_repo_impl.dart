import '../data_sources/services_remote_data_source.dart';
import '../models/service_item_model.dart';
import 'services_repo.dart';

class ServicesRepoImpl implements ServicesRepo {
  final ServicesRemoteDataSource _remoteDataSource;

  ServicesRepoImpl(this._remoteDataSource);

  @override
  Future<List<ServiceItemModel>> getServices() async {
    try {
      return await _remoteDataSource.fetchServices();
    } catch (e) {
      // Allow exceptions to propagate to Cubit layer
      rethrow;
    }
  }
}
