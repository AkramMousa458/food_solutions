import '../models/statistics_model.dart';

abstract class StatisticsRepo {
  Stream<StatisticsModel> getStatistics();
}
