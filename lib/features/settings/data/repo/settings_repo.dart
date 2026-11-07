import 'package:dartz/dartz.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/settings/data/models/delete_account_response.dart';
import 'package:food_solutions/features/settings/data/models/settings_preferences.dart';

abstract class SettingsRepo {
  SettingsPreferences readPreferences();

  Future<void> saveSalesAlerts(bool isEnabled);

  Future<void> saveBiometricLogin(bool isEnabled);

  Future<void> clearSession();

  Future<Either<ServerFailure, DeleteAccountResponse>> deleteAccount();
}
