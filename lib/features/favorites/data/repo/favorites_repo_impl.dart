import '../data_sources/favorites_local_data_source.dart';
import 'favorites_repo.dart';

class FavoritesRepoImpl implements FavoritesRepo {
  final FavoritesLocalDataSource _localDataSource;

  FavoritesRepoImpl(this._localDataSource);

  @override
  List<int> getFavoriteIds() => _localDataSource.getFavoriteIds();

  @override
  bool isFavorite(int serviceId) =>
      _localDataSource.getFavoriteIds().contains(serviceId);

  @override
  Future<void> toggleFavorite(int serviceId) async {
    final ids = List<int>.from(_localDataSource.getFavoriteIds());
    if (ids.contains(serviceId)) {
      ids.remove(serviceId);
    } else {
      ids.add(serviceId);
    }
    await _localDataSource.saveFavoriteIds(ids);
  }
}
