import 'dart:convert';

import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import '../models/home_section_model.dart';

abstract class HomeSectionsLocalDataSource {
  List<HomeSectionModel>? getCachedHomeSections();
  Future<void> cacheHomeSections(List<HomeSectionModel> sections);
}

class HomeSectionsLocalDataSourceImpl implements HomeSectionsLocalDataSource {
  final LocalStorage _localStorage;

  HomeSectionsLocalDataSourceImpl(this._localStorage);

  @override
  List<HomeSectionModel>? getCachedHomeSections() {
    final jsonString = _localStorage.getString(AppConstants.homeSectionsKey);
    if (jsonString == null) return null;
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((item) => HomeSectionModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheHomeSections(List<HomeSectionModel> sections) async {
    final jsonString = jsonEncode(
      sections.map((section) => section.toJson()).toList(),
    );
    await _localStorage.setString(AppConstants.homeSectionsKey, jsonString);
  }
}
