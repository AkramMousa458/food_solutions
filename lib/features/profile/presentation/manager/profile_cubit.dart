import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(const ProfileLoading());

  void loadProfile() {
    emit(const ProfileLoading());
    final profile = _profileRepo.readProfile();
    if (profile == null) {
      emit(const ProfileFailure(message: 'profile_unavailable'));
      return;
    }
    emit(ProfileSuccess(profile: profile));
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
}
