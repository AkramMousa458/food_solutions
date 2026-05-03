import '../data_sources/home_sections_remote_data_source.dart';
import '../models/home_section_model.dart';
import 'home_sections_repo.dart';

class HomeSectionsRepoImpl implements HomeSectionsRepo {
  final HomeSectionsRemoteDataSource _remoteDataSource;

  HomeSectionsRepoImpl(this._remoteDataSource);

  @override
  Future<List<HomeSectionModel>> getHomeSections() async {
    try {
      return await _remoteDataSource.getHomeSections();
    } catch (e) {
      rethrow;
    }
  }
}
