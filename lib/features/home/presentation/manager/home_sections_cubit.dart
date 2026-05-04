import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/home/data/repo/home_sections_repo.dart';
import 'home_sections_state.dart';

class HomeSectionsCubit extends Cubit<HomeSectionsState> {
  final HomeSectionsRepo _repo;

  HomeSectionsCubit(this._repo) : super(HomeSectionsInitial());

  Future<void> getHomeSections() async {
    if (!isClosed) emit(HomeSectionsLoading());
    try {
      await for (final sections in _repo.getHomeSections()) {
        if (!isClosed) emit(HomeSectionsSuccess(sections));
      }
    } catch (e) {
      if (state is! HomeSectionsSuccess) {
        String errorMessage;
        if (e is DioException) {
          errorMessage = ServerFailure.fromDioError(e).message;
        } else {
          errorMessage = e.toString();
        }
        if (!isClosed) emit(HomeSectionsFailure(errorMessage));
      }
    }
  }
}
