import 'dart:convert';

import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/utils/local_storage.dart';

abstract class FavoritesLocalDataSource {
  List<int> getFavoriteIds();
  Future<void> saveFavoriteIds(List<int> ids);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final LocalStorage _localStorage;

  FavoritesLocalDataSourceImpl(this._localStorage);

  @override
  List<int> getFavoriteIds() {
    final jsonString = _localStorage.getString(AppConstants.favoritesKey);
    if (jsonString == null) return [];
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded.map((e) => e as int).toList();
  }

  @override
  Future<void> saveFavoriteIds(List<int> ids) async {
    await _localStorage.setString(
      AppConstants.favoritesKey,
      jsonEncode(ids),
    );
  }
}
