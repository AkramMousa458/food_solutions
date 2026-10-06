import 'package:food_solutions/features/settings/data/models/settings_preferences.dart';

abstract class SettingsRepo {
  SettingsPreferences readPreferences();

  Future<void> saveSalesAlerts(bool isEnabled);

  Future<void> saveBiometricLogin(bool isEnabled);

  Future<void> clearSession();
}
