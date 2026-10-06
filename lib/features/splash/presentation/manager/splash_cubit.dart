import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/splash/presentation/manager/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepo _authRepo;

  SplashCubit(this._authRepo) : super(const SplashChecking());

  void resolveSession() {
    if (_authRepo.hasAuthToken()) {
      emit(const SplashAuthenticated());
      return;
    }
    emit(const SplashUnauthenticated());
  }
}
