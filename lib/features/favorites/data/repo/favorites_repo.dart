abstract class FavoritesRepo {
  List<int> getFavoriteIds();
  Future<void> toggleFavorite(int serviceId);
  bool isFavorite(int serviceId);
}
