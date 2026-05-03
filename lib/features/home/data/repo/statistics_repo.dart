import '../models/statistics_model.dart';

abstract class StatisticsRepo {
  Future<StatisticsModel> getStatistics();
}
