import '../data_sources/statistics_local_data_source.dart';
import '../data_sources/statistics_remote_data_source.dart';
import '../models/statistics_model.dart';
import 'statistics_repo.dart';

class StatisticsRepoImpl implements StatisticsRepo {
  final StatisticsRemoteDataSource _remoteDataSource;
  final StatisticsLocalDataSource _localDataSource;

  StatisticsRepoImpl({
    required StatisticsRemoteDataSource remoteDataSource,
    required StatisticsLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Stream<StatisticsModel> getStatistics() async* {
    final cached = _localDataSource.getCachedStatistics();
    if (cached != null) {
      yield cached;
    }
    final fresh = await _remoteDataSource.getStatistics();
    await _localDataSource.cacheStatistics(fresh);
    yield fresh;
  }
}
