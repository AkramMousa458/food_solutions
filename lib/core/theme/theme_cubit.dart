import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/theme/theme_dark.dart';
import 'package:food_solutions/core/theme/theme_light.dart';
import 'package:food_solutions/core/utils/local_storage.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final LocalStorage localStorage;
  static const String _themeKey = 'theme_mode';

  ThemeCubit({
    required this.localStorage,
    required Brightness initialBrightness,
  }) : super(initialBrightness == Brightness.dark ? darkTheme : lightTheme);

  Future<void> setLightTheme() async {
    emit(lightTheme);
    await localStorage.setString(_themeKey, 'light');
  }

  Future<void> setDarkTheme() async {
    emit(darkTheme);
    await localStorage.setString(_themeKey, 'dark');
  }

  Future<void> toggleTheme() async {
    if (state.brightness == Brightness.dark) {
      await setLightTheme();
      return;
    }
    await setDarkTheme();
  }

  static Brightness getInitialBrightness(LocalStorage localStorage) {
    final saved = localStorage.getString(_themeKey);
    if (saved == 'dark') return Brightness.dark;
    return Brightness.light;
  }
}
