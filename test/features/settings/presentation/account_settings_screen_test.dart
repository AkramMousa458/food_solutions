import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/language/language_cubit.dart';
import 'package:food_solutions/core/theme/theme_cubit.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/settings/data/models/settings_preferences.dart';
import 'package:food_solutions/features/settings/data/repo/settings_repo.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_cubit.dart';
import 'package:food_solutions/features/settings/presentation/screens/account_settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await AppTranslations().setLocale(const Locale('en'));
    await locator.reset();
  });

  testWidgets('shows appearance, language, and delete account', (tester) async {
    await _pumpSettings(tester, repository: _MemorySettingsRepo());
    expect(find.text('App language'), findsOneWidget);
    expect(find.text('Warm day mode'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('settings-delete')),
      300,
    );
    expect(find.text('Delete account permanently'), findsOneWidget);
    expect(find.byKey(const Key('settings-logout')), findsNothing);
  });

  testWidgets('deletes the account after confirmation', (tester) async {
    await _pumpSettings(tester, repository: _MemorySettingsRepo());
    await tester.scrollUntilVisible(
      find.byKey(const Key('settings-delete')),
      300,
    );
    await tester.tap(find.byKey(const Key('settings-delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings-delete-confirm')));
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
  });

  testWidgets('arabic settings layout fits the screen', (tester) async {
    await _pumpSettings(
      tester,
      repository: _MemorySettingsRepo(),
      locale: const Locale('ar'),
    );
    expect(find.text('المظهر واللغة'), findsOneWidget);
    expect(find.text('لغة التطبيق'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('حذف الحساب نهائياً لا رجعة فيه'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpSettings(
  WidgetTester tester, {
  required _MemorySettingsRepo repository,
  Locale locale = const Locale('en'),
}) async {
  SharedPreferences.setMockInitialValues({});
  await locator.reset();
  locator.registerFactory<SettingsCubit>(
    () => SettingsCubit(repository, _MockProfileRepo()),
  );
  final storage = await LocalStorage.init(logger: Logger(level: Level.off));
  final translations = await AppTranslations.init(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'ar'],
  );
  await translations.setLocale(locale);
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(375, 812);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final router = GoRouter(
    initialLocation: AccountSettingsScreen.routeName,
    routes: [
      GoRoute(
        path: AccountSettingsScreen.routeName,
        builder: (context, state) => const AccountSettingsScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const Scaffold(body: Text('Welcome')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    LocalizedApp(
      translations,
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ThemeCubit(
              localStorage: storage,
              initialBrightness: Brightness.light,
            ),
          ),
          BlocProvider(
            create: (_) =>
                LanguageCubit(localStorage: storage, initialLocale: locale),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, _) {
            return MaterialApp.router(
              routerConfig: router,
              locale: locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _MockProfileRepo implements ProfileRepo {
  @override
  Future<Either<ServerFailure, ProfileSnapshot>> fetchAccount() async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
  }

  @override
  ProfileSnapshot? readProfile() {
    return const ProfileSnapshot(
      name: 'Khalid bin Abdulaziz',
      role: 'restaurant_manager',
      phone: '',
      email: 'khalid@foodguide.sa',
      initials: 'K',
    );
  }
}

class _MemorySettingsRepo implements SettingsRepo {
  SettingsPreferences preferences = const SettingsPreferences(
    isSalesAlertsEnabled: true,
    isBiometricLoginEnabled: false,
  );

  @override
  Future<void> clearSession() async {}

  @override
  SettingsPreferences readPreferences() => preferences;

  @override
  Future<void> saveBiometricLogin(bool isEnabled) async {
    preferences = preferences.copyWith(isBiometricLoginEnabled: isEnabled);
  }

  @override
  Future<void> saveSalesAlerts(bool isEnabled) async {
    preferences = preferences.copyWith(isSalesAlertsEnabled: isEnabled);
  }
}
