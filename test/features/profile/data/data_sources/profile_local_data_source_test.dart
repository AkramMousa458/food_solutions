import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('reads the profile saved with the session', () async {
    final inputJson = <String, dynamic>{
      'name': 'Abdullah Al Saeed',
      'phone': '+966501234567',
      'email': 'abdullah@foodsolutions.sa',
      'role': 'owner',
      'establishments': [
        {'name': 'Nirvana Cafe'},
      ],
    };
    SharedPreferences.setMockInitialValues({
      AppConstants.userProfileKey: jsonEncode(inputJson),
    });
    final storage = await LocalStorage.init(logger: Logger(level: Level.off));
    final dataSource = ProfileLocalDataSourceImpl(storage);
    final actualProfile = dataSource.readProfile();
    expect(actualProfile?.name, 'Abdullah Al Saeed');
    expect(actualProfile?.establishments.single.name, 'Nirvana Cafe');
  });

  test('saves the account profile for the next read', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorage.init(logger: Logger(level: Level.off));
    final dataSource = ProfileLocalDataSourceImpl(storage);
    const inputProfile = ProfileSnapshot(
      name: 'Akram Mousa',
      role: 'admin',
      phone: '01097066403',
      email: 'akrammousa458@gmail.com',
      initials: 'AM',
    );
    await dataSource.saveProfile(inputProfile);
    expect(dataSource.readProfile(), inputProfile);
  });

  test('returns null when the saved profile cannot be read', () async {
    SharedPreferences.setMockInitialValues({AppConstants.userProfileKey: '{'});
    final storage = await LocalStorage.init(logger: Logger(level: Level.off));
    final dataSource = ProfileLocalDataSourceImpl(storage);
    expect(dataSource.readProfile(), isNull);
  });
}
