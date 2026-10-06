import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/settings/data/models/settings_preferences.dart';
import 'package:food_solutions/features/settings/data/repo/settings_repo.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_cubit.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_state.dart';

void main() {
  test('loads the saved profile and preferences', () {
    final inputProfile = _profile();
    final inputPreferences = const SettingsPreferences(
      isSalesAlertsEnabled: true,
      isBiometricLoginEnabled: false,
    );
    final mockSettingsRepo = _MockSettingsRepo(preferences: inputPreferences);
    final mockProfileRepo = _MockProfileRepo(profile: inputProfile);
    final cubit = SettingsCubit(mockSettingsRepo, mockProfileRepo);
    addTearDown(cubit.close);
    cubit.loadSettings();
    final actualState = cubit.state;
    final expectedState = SettingsReady(
      profile: inputProfile,
      preferences: inputPreferences,
    );
    expect(actualState, expectedState);
  });

  test('saves the sales alerts preference', () async {
    final mockSettingsRepo = _MockSettingsRepo(
      preferences: const SettingsPreferences(
        isSalesAlertsEnabled: true,
        isBiometricLoginEnabled: false,
      ),
    );
    final cubit = SettingsCubit(
      mockSettingsRepo,
      _MockProfileRepo(profile: _profile()),
    );
    addTearDown(cubit.close);
    cubit.loadSettings();
    await cubit.setSalesAlerts(false);
    final actualState = cubit.state as SettingsReady;
    expect(actualState.preferences.isSalesAlertsEnabled, isFalse);
    expect(mockSettingsRepo.savedSalesAlerts, isFalse);
  });

  test('ends the session on logout', () async {
    final mockSettingsRepo = _MockSettingsRepo(
      preferences: const SettingsPreferences(
        isSalesAlertsEnabled: true,
        isBiometricLoginEnabled: false,
      ),
    );
    final cubit = SettingsCubit(
      mockSettingsRepo,
      _MockProfileRepo(profile: null),
    );
    addTearDown(cubit.close);
    cubit.loadSettings();
    await cubit.logout();
    expect(cubit.state, const SettingsSessionEnded());
    expect(mockSettingsRepo.clearCount, 1);
  });
}

ProfileSnapshot _profile() {
  return const ProfileSnapshot(
    name: 'Khalid bin Abdulaziz',
    role: 'restaurant_manager',
    phone: '',
    email: 'khalid@foodguide.sa',
    initials: 'K',
  );
}

class _MockProfileRepo implements ProfileRepo {
  final ProfileSnapshot? profile;

  _MockProfileRepo({required this.profile});

  @override
  Future<Either<ServerFailure, ProfileSnapshot>> fetchAccount() async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
  }

  @override
  ProfileSnapshot? readProfile() => profile;
}

class _MockSettingsRepo implements SettingsRepo {
  SettingsPreferences preferences;
  bool? savedSalesAlerts;
  int clearCount = 0;

  _MockSettingsRepo({required this.preferences});

  @override
  Future<void> clearSession() async {
    clearCount++;
  }

  @override
  SettingsPreferences readPreferences() => preferences;

  @override
  Future<void> saveBiometricLogin(bool isEnabled) async {}

  @override
  Future<void> saveSalesAlerts(bool isEnabled) async {
    savedSalesAlerts = isEnabled;
    preferences = preferences.copyWith(isSalesAlertsEnabled: isEnabled);
  }
}
