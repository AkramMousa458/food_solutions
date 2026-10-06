import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_session_data_source.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:food_solutions/features/settings/data/models/settings_preferences.dart';
import 'package:food_solutions/features/settings/data/repo/settings_repo_impl.dart';

void main() {
  test('clears the saved session', () async {
    final mockSession = _MockAuthSession();
    final repository = SettingsRepoImpl(
      _MockSettingsLocalDataSource(),
      mockSession,
    );
    await repository.clearSession();
    expect(mockSession.clearCount, 1);
  });

  test('returns the stored preferences', () {
    final inputPreferences = const SettingsPreferences(
      isSalesAlertsEnabled: false,
      isBiometricLoginEnabled: true,
    );
    final repository = SettingsRepoImpl(
      _MockSettingsLocalDataSource(preferences: inputPreferences),
      _MockAuthSession(),
    );
    final actualPreferences = repository.readPreferences();
    expect(actualPreferences, inputPreferences);
  });
}

class _MockSettingsLocalDataSource implements SettingsLocalDataSource {
  final SettingsPreferences preferences;

  _MockSettingsLocalDataSource({
    this.preferences = const SettingsPreferences(
      isSalesAlertsEnabled: true,
      isBiometricLoginEnabled: false,
    ),
  });

  @override
  SettingsPreferences readPreferences() => preferences;

  @override
  Future<void> saveBiometricLogin(bool isEnabled) async {}

  @override
  Future<void> saveSalesAlerts(bool isEnabled) async {}
}

class _MockAuthSession implements AuthSessionDataSource {
  int clearCount = 0;

  @override
  Future<void> clearSession() async {
    clearCount++;
  }

  @override
  String? readToken() => null;

  @override
  Future<void> saveSession(LoginResponseModel session) async {}
}
