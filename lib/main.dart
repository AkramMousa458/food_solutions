import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/language/language_cubit.dart';
import 'package:food_solutions/core/theme/theme_cubit.dart';
import 'package:food_solutions/core/utils/bloc_observer.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/my_app.dart';
import 'package:logger/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  final logger = Logger();

  try {
    // Initialize service locator with logger
    await setupLocator(logger: logger);

    // Initialize BLoC observer
    Bloc.observer = AppBlocObserver(logger: logger);

    // Initialize local storage
    final localStorage = await LocalStorage.init(logger: logger);

    // Initialize custom translations (replaces flutter_translate)
    final translations = await AppTranslations.init(
      fallbackLocale: 'en',
      supportedLocales: ['en', 'ar'],
      basePath: 'assets/i18n',
    );

    // Get initial theme brightness (saved or device)
    final initialBrightness = Brightness.light;
    // final initialBrightness = await ThemeCubit.getInitialBrightness(
    //   localStorage,
    // );

    // Get initial locale (saved or default)
    final initialLocale = await LanguageCubit.getInitialLocale(localStorage);

    // Set the initial locale in translations
    await translations.setLocale(initialLocale);

    // Run the app
    runApp(
      LocalizedApp(
        translations,
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ThemeCubit(
                localStorage: localStorage,
                initialBrightness: initialBrightness,
              ),
            ),
            BlocProvider(
              create: (_) => LanguageCubit(
                localStorage: localStorage,
                initialLocale: initialLocale,
              ),
            ),
          ],
          child: MyApp(localStorage: localStorage),
        ),
      ),
    );
  } catch (e, stackTrace) {
    logger.e(
      'Application initialization failed',
      error: e,
      stackTrace: stackTrace,
    );
  }
}
