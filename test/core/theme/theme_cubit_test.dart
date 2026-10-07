import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/theme/theme_cubit.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('restores the saved dark theme after restart', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorage.init(logger: Logger(level: Level.off));
    final cubit = ThemeCubit(
      localStorage: storage,
      initialBrightness: Brightness.light,
    );
    addTearDown(cubit.close);
    await cubit.setDarkTheme();
    final actualBrightness = ThemeCubit.getInitialBrightness(storage);
    expect(actualBrightness, Brightness.dark);
  });

  test('restores the saved light theme after restart', () async {
    SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
    final storage = await LocalStorage.init(logger: Logger(level: Level.off));
    final cubit = ThemeCubit(
      localStorage: storage,
      initialBrightness: ThemeCubit.getInitialBrightness(storage),
    );
    addTearDown(cubit.close);
    expect(cubit.state.brightness, Brightness.dark);
    await cubit.setLightTheme();
    final actualBrightness = ThemeCubit.getInitialBrightness(storage);
    expect(actualBrightness, Brightness.light);
  });

  test('defaults to light when no theme is saved', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorage.init(logger: Logger(level: Level.off));
    final actualBrightness = ThemeCubit.getInitialBrightness(storage);
    expect(actualBrightness, Brightness.light);
  });
}
