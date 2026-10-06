import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(const ProfileLoading());

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    final result = await _profileRepo.fetchAccount();
    result.fold(_emitCachedOrFailure, _emitProfile);
  }

  void selectEstablishment(int index) {
    final current = state;
    if (current is! ProfileSuccess) return;
    if (index < 0 || index >= current.profile.establishments.length) return;
    emit(
      ProfileSuccess(
        profile: current.profile,
        selectedEstablishmentIndex: index,
      ),
    );
  }

  void _emitProfile(ProfileSnapshot profile) {
    emit(ProfileSuccess(profile: profile));
  }

  void _emitCachedOrFailure(ServerFailure failure) {
    final cachedProfile = _profileRepo.readProfile();
    if (cachedProfile != null) {
      emit(ProfileSuccess(profile: cachedProfile));
      return;
    }
    emit(ProfileFailure(message: failure.message));
  }
}
