import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_session_data_source.dart';
import 'package:food_solutions/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:food_solutions/features/settings/data/data_sources/settings_remote_data_source.dart';
import 'package:food_solutions/features/settings/data/models/delete_account_response.dart';
import 'package:food_solutions/features/settings/data/models/settings_preferences.dart';
import 'package:food_solutions/features/settings/data/repo/settings_repo.dart';

class SettingsRepoImpl implements SettingsRepo {
  final SettingsLocalDataSource _localDataSource;
  final SettingsRemoteDataSource _remoteDataSource;
  final AuthSessionDataSource _sessionDataSource;

  SettingsRepoImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._sessionDataSource,
  );

  @override
  SettingsPreferences readPreferences() => _localDataSource.readPreferences();

  @override
  Future<void> saveSalesAlerts(bool isEnabled) {
    return _localDataSource.saveSalesAlerts(isEnabled);
  }

  @override
  Future<void> saveBiometricLogin(bool isEnabled) {
    return _localDataSource.saveBiometricLogin(isEnabled);
  }

  @override
  Future<void> clearSession() => _sessionDataSource.clearSession();

  @override
  Future<Either<ServerFailure, DeleteAccountResponse>> deleteAccount() async {
    try {
      final response = await _remoteDataSource.deleteAccount();
      final deleted = DeleteAccountResponse.fromJson(response);
      if (!deleted.isSuccess) return Left(_unsuccessful(deleted.message));
      await clearSession();
      return Right(deleted);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (_) {
      return Left(_unexpectedFailure());
    }
  }

  ServerFailure _unsuccessful(String message) {
    final trimmed = message.trim();
    return ServerFailure(
      message: trimmed.isEmpty ? ApiErrorMessages.unexpectedError : trimmed,
      status: ApiFailureStatus.unsuccessful,
    );
  }

  ServerFailure _unexpectedFailure() {
    return ServerFailure(
      message: ApiErrorMessages.unexpectedError,
      status: ApiFailureStatus.unexpected,
    );
  }
}
