import '../data_sources/services_local_data_source.dart';
import '../data_sources/services_remote_data_source.dart';
import '../models/service_item_model.dart';
import 'services_repo.dart';

class ServicesRepoImpl implements ServicesRepo {
  final ServicesRemoteDataSource _remoteDataSource;
  final ServicesLocalDataSource _localDataSource;

  ServicesRepoImpl({
    required ServicesRemoteDataSource remoteDataSource,
    required ServicesLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  /// Emits the cached list immediately (if present), then fetches fresh data
  /// from the API, caches it, and emits the updated list.
  @override
  Stream<List<ServiceItemModel>> getServices() async* {
    final cached = _localDataSource.getCachedServices();
    if (cached != null && cached.isNotEmpty) {
      yield cached;
    }
    final fresh = await _remoteDataSource.fetchServices();
    await _localDataSource.cacheServices(fresh);
    yield fresh;
  }
}
