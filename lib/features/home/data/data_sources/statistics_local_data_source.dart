import 'dart:convert';

import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import '../models/statistics_model.dart';

abstract class StatisticsLocalDataSource {
  StatisticsModel? getCachedStatistics();
  Future<void> cacheStatistics(StatisticsModel statistics);
}

class StatisticsLocalDataSourceImpl implements StatisticsLocalDataSource {
  final LocalStorage _localStorage;

  StatisticsLocalDataSourceImpl(this._localStorage);

  @override
  StatisticsModel? getCachedStatistics() {
    final jsonString = _localStorage.getString(AppConstants.statisticsKey);
    if (jsonString == null) return null;
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return StatisticsModel.fromJson(decoded);
  }

  @override
  Future<void> cacheStatistics(StatisticsModel statistics) async {
    final jsonString = jsonEncode(statistics.toJson());
    await _localStorage.setString(AppConstants.statisticsKey, jsonString);
  }
}
