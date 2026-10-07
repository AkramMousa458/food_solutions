import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/delete_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/models/update_profile_request.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/settings/data/models/delete_account_response.dart';
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

  test('deletes the account and ends the session', () async {
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
    await cubit.deleteAccount();
    expect(
      cubit.state,
      const SettingsSessionEnded(message: 'Account deleted successfully.'),
    );
    expect(mockSettingsRepo.deleteCount, 1);
  });

  test('keeps the session when delete account fails', () async {
    const inputMessage = 'Unable to delete account.';
    final mockSettingsRepo = _MockSettingsRepo(
      preferences: const SettingsPreferences(
        isSalesAlertsEnabled: true,
        isBiometricLoginEnabled: false,
      ),
      deleteFailure: const ServerFailure(
        message: inputMessage,
        status: ApiFailureStatus.unsuccessful,
      ),
    );
    final cubit = SettingsCubit(
      mockSettingsRepo,
      _MockProfileRepo(profile: null),
    );
    addTearDown(cubit.close);
    cubit.loadSettings();
    await cubit.deleteAccount();
    final actualState = cubit.state as SettingsReady;
    expect(actualState.isDeleting, isFalse);
    expect(actualState.feedback?.message, inputMessage);
    expect(actualState.feedback?.isError, isTrue);
    expect(mockSettingsRepo.deleteCount, 1);
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
  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  createEstablishment(CreateEstablishmentRequest request) async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  updateEstablishment(int id, CreateEstablishmentRequest request) async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, DeleteEstablishmentResponse>>
  deleteEstablishment(int id) async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, ProfileSnapshot>> updateAccount(
    UpdateProfileRequest request,
  ) async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
  }

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
  int deleteCount = 0;
  final ServerFailure? deleteFailure;

  _MockSettingsRepo({required this.preferences, this.deleteFailure});

  @override
  Future<void> clearSession() async {
    clearCount++;
  }

  @override
  Future<Either<ServerFailure, DeleteAccountResponse>> deleteAccount() async {
    deleteCount++;
    final failure = deleteFailure;
    if (failure != null) return Left(failure);
    return const Right(
      DeleteAccountResponse(
        isSuccess: true,
        message: 'Account deleted successfully.',
      ),
    );
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
