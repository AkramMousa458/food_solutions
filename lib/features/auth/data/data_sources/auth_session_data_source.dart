import 'dart:convert';

import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/services/api_service.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';

abstract class AuthSessionDataSource {
  Future<void> saveSession(LoginResponseModel session);

  String? readToken();

  Future<void> clearSession();

  Future<void> enterGuestMode();

  bool isGuest();
}

class AuthSessionDataSourceImpl implements AuthSessionDataSource {
  final LocalStorage _localStorage;
  final ApiService _apiService;

  AuthSessionDataSourceImpl(this._localStorage, this._apiService);

  @override
  Future<void> saveSession(LoginResponseModel session) async {
    await _localStorage.setString(AppConstants.authTokenKey, session.token);
    await _localStorage.setString(
      AppConstants.userProfileKey,
      jsonEncode(session.user.toJson()),
    );
    _apiService.setAuthToken(session.token);
    await _localStorage.setBool(AppConstants.guestModeKey, false);
  }

  @override
  String? readToken() {
    final token = _localStorage.getString(AppConstants.authTokenKey);
    if (token == null || token.trim().isEmpty) return null;
    _apiService.setAuthToken(token);
    return token;
  }

  @override
  Future<void> clearSession() async {
    await _localStorage.remove(AppConstants.authTokenKey);
    await _localStorage.remove(AppConstants.userProfileKey);
    await _localStorage.setBool(AppConstants.guestModeKey, false);
    _apiService.setAuthToken(null);
  }

  @override
  Future<void> enterGuestMode() async {
    await _localStorage.setBool(AppConstants.guestModeKey, true);
    _apiService.setAuthToken(null);
  }

  @override
  bool isGuest() => _localStorage.getBool(AppConstants.guestModeKey) ?? false;
}
