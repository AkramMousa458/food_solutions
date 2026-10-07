import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_session_data_source.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:food_solutions/features/settings/data/data_sources/settings_remote_data_source.dart';
import 'package:food_solutions/features/settings/data/models/settings_preferences.dart';
import 'package:food_solutions/features/settings/data/repo/settings_repo_impl.dart';

void main() {
  test('clears the saved session', () async {
    final mockSession = _MockAuthSession();
    final repository = SettingsRepoImpl(
      _MockSettingsLocalDataSource(),
      _MockSettingsRemoteDataSource(),
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
      _MockSettingsRemoteDataSource(),
      _MockAuthSession(),
    );
    final actualPreferences = repository.readPreferences();
    expect(actualPreferences, inputPreferences);
  });

  test('deletes the account and clears the session', () async {
    final mockSession = _MockAuthSession();
    final mockRemote = _MockSettingsRemoteDataSource(
      response: <String, dynamic>{
        'success': true,
        'message': 'Account deleted successfully.',
      },
    );
    final repository = SettingsRepoImpl(
      _MockSettingsLocalDataSource(),
      mockRemote,
      mockSession,
    );
    final actualResult = await repository.deleteAccount();
    final actualResponse = actualResult.fold(
      (_) => throw StateError('expected success'),
      (response) => response,
    );
    expect(actualResponse.isSuccess, isTrue);
    expect(actualResponse.message, 'Account deleted successfully.');
    expect(mockRemote.deleteCount, 1);
    expect(mockSession.clearCount, 1);
  });

  test('keeps the session when delete account is unsuccessful', () async {
    final mockSession = _MockAuthSession();
    final repository = SettingsRepoImpl(
      _MockSettingsLocalDataSource(),
      _MockSettingsRemoteDataSource(
        response: <String, dynamic>{
          'success': false,
          'message': 'Unable to delete account.',
        },
      ),
      mockSession,
    );
    final actualResult = await repository.deleteAccount();
    final actualFailure = actualResult.fold(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.message, 'Unable to delete account.');
    expect(actualFailure.status, ApiFailureStatus.unsuccessful);
    expect(mockSession.clearCount, 0);
  });

  test('maps dio errors from delete account', () async {
    final requestOptions = RequestOptions(path: 'api/account');
    final repository = SettingsRepoImpl(
      _MockSettingsLocalDataSource(),
      _MockSettingsRemoteDataSource(
        error: DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.badResponse,
          response: Response<Map<String, dynamic>>(
            requestOptions: requestOptions,
            statusCode: 401,
            data: <String, dynamic>{'message': 'Unauthenticated.'},
          ),
        ),
      ),
      _MockAuthSession(),
    );
    final actualResult = await repository.deleteAccount();
    final actualFailure = actualResult.fold(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.status, ApiFailureStatus.unauthorized);
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

class _MockSettingsRemoteDataSource implements SettingsRemoteDataSource {
  final Map<String, dynamic> response;
  final DioException? error;
  int deleteCount = 0;

  _MockSettingsRemoteDataSource({
    this.response = const <String, dynamic>{},
    this.error,
  });

  @override
  Future<Map<String, dynamic>> deleteAccount() async {
    deleteCount++;
    final failure = error;
    if (failure != null) throw failure;
    return response;
  }
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
