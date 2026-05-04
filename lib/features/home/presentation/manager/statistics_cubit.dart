import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/home/data/repo/statistics_repo.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepo _repo;

  StatisticsCubit(this._repo) : super(StatisticsInitial());

  Future<void> getStatistics() async {
    if (!isClosed) emit(StatisticsLoading());
    try {
      await for (final statistics in _repo.getStatistics()) {
        if (!isClosed) emit(StatisticsSuccess(statistics));
      }
    } catch (e) {
      if (state is! StatisticsSuccess) {
        String errorMessage;
        if (e is DioException) {
          errorMessage = ServerFailure.fromDioError(e).message;
        } else {
          errorMessage = e.toString();
        }
        if (!isClosed) emit(StatisticsFailure(errorMessage));
      }
    }
  }
}
