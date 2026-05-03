import '../data_sources/statistics_remote_data_source.dart';
import '../models/statistics_model.dart';
import 'statistics_repo.dart';

class StatisticsRepoImpl implements StatisticsRepo {
  final StatisticsRemoteDataSource _remoteDataSource;

  StatisticsRepoImpl(this._remoteDataSource);

  @override
  Future<StatisticsModel> getStatistics() async {
    try {
      return await _remoteDataSource.getStatistics();
    } catch (e) {
      rethrow;
    }
  }
}
