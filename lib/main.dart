import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/constants.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/language/language_cubit.dart';
import 'package:food_solutions/core/services/firebase_messaging_background_handler.dart';
import 'package:food_solutions/core/services/push_notification_service.dart';
import 'package:food_solutions/core/theme/theme_cubit.dart';
import 'package:food_solutions/core/utils/bloc_observer.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/features/favorites/presentation/manager/favorites_cubit.dart';
import 'package:food_solutions/features/reviews/presentation/manager/reviews_cubit.dart';
import 'package:food_solutions/firebase_options.dart';
import 'package:food_solutions/my_app.dart';
import 'package:logger/logger.dart';

Future<void> _persistFcmToken(LocalStorage storage, String? token) async {
  if (token == null || token.isEmpty) return;

  await storage.setString(AppConstants.fcmTokenKey, token);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = Logger();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await PushNotificationService.instance.initialize();

    final fcmToken = await PushNotificationService.instance.getFcmToken();
    if (fcmToken != null) {
      logger.i('FCM token obtained: $fcmToken');
    } else {
      logger.w('FCM token unavailable (permissions or APNS may be pending)');
    }

    await PushNotificationService.instance.subscribeToTopic(
      PushNotificationService.allUsersTopic,
    );
    logger.i(
      'Subscribed to FCM topic: ${PushNotificationService.allUsersTopic}',
    );

    await setupLocator(logger: logger);

    locator<FavoritesCubit>().loadFavorites();

    locator<ReviewsCubit>().loadReviews();

    Bloc.observer = AppBlocObserver(logger: logger);
    final localStorage = await LocalStorage.init(logger: logger);
    await _persistFcmToken(localStorage, fcmToken);
    PushNotificationService.instance.onFcmTokenRefreshed = (token) {
      logger.i('FCM token refreshed: $token');

      _persistFcmToken(localStorage, token);
    };

    final translations = await AppTranslations.init(
      fallbackLocale: 'en',

      supportedLocales: ['en', 'ar'],

      basePath: 'assets/i18n',
    );

    final initialBrightness = Brightness.light;
    final initialLocale = await LanguageCubit.getInitialLocale(localStorage);
    await translations.setLocale(initialLocale);

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
            BlocProvider.value(value: locator<FavoritesCubit>()),
            BlocProvider.value(value: locator<ReviewsCubit>()),
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
