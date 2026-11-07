import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/features/settings/data/models/settings_preferences.dart';

abstract class SettingsLocalDataSource {
  SettingsPreferences readPreferences();

  Future<void> saveSalesAlerts(bool isEnabled);

  Future<void> saveBiometricLogin(bool isEnabled);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final LocalStorage _localStorage;

  SettingsLocalDataSourceImpl(this._localStorage);

  @override
  SettingsPreferences readPreferences() {
    return SettingsPreferences(
      isSalesAlertsEnabled:
          _localStorage.getBool(AppConstants.salesAlertsKey) ?? true,
      isBiometricLoginEnabled:
          _localStorage.getBool(AppConstants.biometricLoginKey) ?? false,
    );
  }

  @override
  Future<void> saveSalesAlerts(bool isEnabled) async {
    await _localStorage.setBool(AppConstants.salesAlertsKey, isEnabled);
  }

  @override
  Future<void> saveBiometricLogin(bool isEnabled) async {
    await _localStorage.setBool(AppConstants.biometricLoginKey, isEnabled);
  }
}
