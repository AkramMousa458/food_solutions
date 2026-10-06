import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('reads saved alert and biometric preferences', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.salesAlertsKey: false,
      AppConstants.biometricLoginKey: true,
    });
    final storage = await LocalStorage.init(logger: Logger(level: Level.off));
    final dataSource = SettingsLocalDataSourceImpl(storage);
    final actualPreferences = dataSource.readPreferences();
    expect(actualPreferences.isSalesAlertsEnabled, isFalse);
    expect(actualPreferences.isBiometricLoginEnabled, isTrue);
  });

  test('saves the sales alerts preference', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorage.init(logger: Logger(level: Level.off));
    final dataSource = SettingsLocalDataSourceImpl(storage);
    await dataSource.saveSalesAlerts(false);
    final actualPreferences = dataSource.readPreferences();
    expect(actualPreferences.isSalesAlertsEnabled, isFalse);
  });
}
