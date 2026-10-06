import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/settings/data/repo/settings_repo.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepo _settingsRepo;
  final ProfileRepo _profileRepo;

  SettingsCubit(this._settingsRepo, this._profileRepo)
    : super(const SettingsLoading());

  void loadSettings() {
    emit(const SettingsLoading());
    final preferences = _settingsRepo.readPreferences();
    final profile = _profileRepo.readProfile();
    emit(SettingsReady(profile: profile, preferences: preferences));
  }

  Future<void> setSalesAlerts(bool isEnabled) async {
    await _updatePreferences((current) {
      return current.copyWith(
        preferences: current.preferences.copyWith(
          isSalesAlertsEnabled: isEnabled,
        ),
      );
    }, () => _settingsRepo.saveSalesAlerts(isEnabled));
  }

  Future<void> setBiometricLogin(bool isEnabled) async {
    await _updatePreferences((current) {
      return current.copyWith(
        preferences: current.preferences.copyWith(
          isBiometricLoginEnabled: isEnabled,
        ),
      );
    }, () => _settingsRepo.saveBiometricLogin(isEnabled));
  }

  Future<void> logout() => _endSession();

  Future<void> deleteAccount() => _endSession();

  Future<void> _updatePreferences(
    SettingsReady Function(SettingsReady current) update,
    Future<void> Function() save,
  ) async {
    final current = state;
    if (current is! SettingsReady) return;
    await save();
    emit(update(current));
  }

  Future<void> _endSession() async {
    await _settingsRepo.clearSession();
    emit(const SettingsSessionEnded());
  }
}
