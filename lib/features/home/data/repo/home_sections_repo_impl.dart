import '../data_sources/home_sections_local_data_source.dart';
import '../data_sources/home_sections_remote_data_source.dart';
import '../models/home_section_model.dart';
import 'home_sections_repo.dart';

class HomeSectionsRepoImpl implements HomeSectionsRepo {
  final HomeSectionsRemoteDataSource _remoteDataSource;
  final HomeSectionsLocalDataSource _localDataSource;

  HomeSectionsRepoImpl({
    required HomeSectionsRemoteDataSource remoteDataSource,
    required HomeSectionsLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Stream<List<HomeSectionModel>> getHomeSections() async* {
    final cached = _localDataSource.getCachedHomeSections();
    if (cached != null && cached.isNotEmpty) {
      yield cached;
    }
    final fresh = await _remoteDataSource.getHomeSections();
    await _localDataSource.cacheHomeSections(fresh);
    yield fresh;
  }
}
