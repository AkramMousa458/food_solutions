import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/favorites_repo.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepo _repo;

  FavoritesCubit(this._repo) : super(FavoritesInitial());

  void loadFavorites() {
    emit(FavoritesLoaded(_repo.getFavoriteIds()));
  }

  Future<void> toggleFavorite(int serviceId) async {
    await _repo.toggleFavorite(serviceId);
    emit(FavoritesLoaded(_repo.getFavoriteIds()));
  }

  bool isFavorite(int serviceId) => _repo.isFavorite(serviceId);
}
