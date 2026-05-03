import 'package:equatable/equatable.dart';
import 'package:food_solutions/features/home/data/models/statistics_model.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsSuccess extends StatisticsState {
  final StatisticsModel statistics;

  const StatisticsSuccess(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

class StatisticsFailure extends StatisticsState {
  final String errorMessage;

  const StatisticsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
