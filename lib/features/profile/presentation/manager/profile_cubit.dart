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
    if (current is! ProfileSuccess || current.isBusy) return;
    if (index < 0 || index >= current.profile.establishments.length) return;
    emit(
      ProfileSuccess(
        profile: current.profile,
        selectedEstablishmentIndex: index,
      ),
    );
  }

  Future<void> deleteEstablishment(int id) async {
    final current = state;
    if (current is! ProfileSuccess || current.isBusy) return;
    emit(
      ProfileSuccess(
        profile: current.profile,
        selectedEstablishmentIndex: current.selectedEstablishmentIndex,
        isBusy: true,
      ),
    );
    final result = await _profileRepo.deleteEstablishment(id);
    result.fold(
      (failure) => _emitProfileFeedback(
        current,
        ProfileFeedback(
          message: failure.message,
          isError: true,
          status: failure.status,
        ),
      ),
      (deleted) => _emitDeleted(current, id, deleted.message),
    );
  }

  void _emitDeleted(ProfileSuccess current, int id, String message) {
    final stored = _profileRepo.readProfile();
    final profile = stored ?? _withoutEstablishment(current.profile, id);
    emit(
      ProfileSuccess(
        profile: profile,
        selectedEstablishmentIndex: _indexAfterRemoval(
          previous: current.profile.establishments,
          next: profile.establishments,
          selectedIndex: current.selectedEstablishmentIndex,
        ),
        feedback: ProfileFeedback(message: message, isError: false),
      ),
    );
  }

  void _emitProfileFeedback(ProfileSuccess current, ProfileFeedback feedback) {
    emit(
      ProfileSuccess(
        profile: current.profile,
        selectedEstablishmentIndex: current.selectedEstablishmentIndex,
        feedback: feedback,
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

  void applyCachedProfile() {
    final cached = _profileRepo.readProfile();
    if (cached == null) return;
    final current = state;
    if (current is! ProfileSuccess) {
      emit(ProfileSuccess(profile: cached));
      return;
    }
    emit(
      ProfileSuccess(
        profile: cached,
        selectedEstablishmentIndex: _indexAfterRemoval(
          previous: current.profile.establishments,
          next: cached.establishments,
          selectedIndex: current.selectedEstablishmentIndex,
        ),
      ),
    );
  }
}

ProfileSnapshot _withoutEstablishment(ProfileSnapshot profile, int id) {
  return profile.copyWith(
    establishments: profile.establishments
        .where((item) => item.id != id)
        .toList(),
  );
}

int _indexAfterRemoval({
  required List<ProfileEstablishmentSnapshot> previous,
  required List<ProfileEstablishmentSnapshot> next,
  required int selectedIndex,
}) {
  if (next.isEmpty) return 0;
  final selected = selectedIndex >= 0 && selectedIndex < previous.length
      ? previous[selectedIndex]
      : null;
  final selectedId = selected?.id;
  if (selectedId != null) {
    final index = next.indexWhere((item) => item.id == selectedId);
    if (index >= 0) return index;
  }
  if (selectedIndex < next.length) return selectedIndex;
  return next.length - 1;
}
