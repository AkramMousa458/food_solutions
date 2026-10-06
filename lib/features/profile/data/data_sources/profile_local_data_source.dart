import 'dart:convert';

import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';

abstract class ProfileLocalDataSource {
  ProfileSnapshot? readProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final LocalStorage _localStorage;

  ProfileLocalDataSourceImpl(this._localStorage);

  @override
  ProfileSnapshot? readProfile() {
    final raw = _localStorage.getString(AppConstants.userProfileKey);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      final profile = ProfileSnapshot.fromJson(
        Map<String, dynamic>.from(decoded),
      );
      if (profile.name.isEmpty &&
          profile.phone.isEmpty &&
          profile.email.isEmpty) {
        return null;
      }
      return profile;
    } catch (_) {
      return null;
    }
  }
}
