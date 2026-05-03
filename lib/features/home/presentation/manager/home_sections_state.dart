import 'package:equatable/equatable.dart';
import 'package:food_solutions/features/home/data/models/home_section_model.dart';

abstract class HomeSectionsState extends Equatable {
  const HomeSectionsState();

  @override
  List<Object?> get props => [];
}

class HomeSectionsInitial extends HomeSectionsState {}

class HomeSectionsLoading extends HomeSectionsState {}

class HomeSectionsSuccess extends HomeSectionsState {
  final List<HomeSectionModel> sections;

  const HomeSectionsSuccess(this.sections);

  @override
  List<Object?> get props => [sections];
}

class HomeSectionsFailure extends HomeSectionsState {
  final String errorMessage;

  const HomeSectionsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
