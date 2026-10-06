import 'dart:convert';

import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/services/api_service.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';

abstract class AuthSessionDataSource {
  Future<void> saveSession(LoginResponseModel session);

  String? readToken();
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
  }

  @override
  String? readToken() {
    final token = _localStorage.getString(AppConstants.authTokenKey);
    if (token == null || token.trim().isEmpty) return null;
    _apiService.setAuthToken(token);
    return token;
  }
}
