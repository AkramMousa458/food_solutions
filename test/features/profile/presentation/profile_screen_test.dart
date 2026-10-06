import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/language/language_cubit.dart';
import 'package:food_solutions/core/theme/theme_cubit.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_cubit.dart';
import 'package:food_solutions/features/profile/presentation/screens/profile_screen.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await AppTranslations().setLocale(const Locale('en'));
    await locator.reset();
  });

  testWidgets('shows the signed-in profile and opens account settings', (
    tester,
  ) async {
    final inputProfile = _profile();
    await _pumpProfile(
      tester,
      profile: inputProfile,
      locale: const Locale('en'),
    );
    expect(find.text('Abdullah Al Saeed'), findsOneWidget);
    expect(find.text('Establishment owner'), findsOneWidget);
    expect(find.text('+966 50 123 4567'), findsOneWidget);
    expect(find.text('abdullah@foodsolutions.sa'), findsOneWidget);
    expect(find.text('Nirvana Cafe'), findsOneWidget);
    expect(find.text('Riyadh'), findsOneWidget);
    expect(find.text('Bakeries'), findsOneWidget);
    expect(find.text('2 years (24 months)'), findsOneWidget);
    expect(find.text('Listed and operating'), findsOneWidget);
    expect(find.text('Edit profile and details'), findsOneWidget);
    await tester.scrollUntilVisible(find.textContaining('Version v1.0.2'), 300);
    expect(find.textContaining('Food Solutions SaaS'), findsOneWidget);
    await tester.tap(find.text('Account settings'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('English'), findsWidgets);
  });

  testWidgets('switches the current establishment', (tester) async {
    await _pumpProfile(
      tester,
      profile: _profile(
        establishments: const [
          ProfileEstablishmentSnapshot(name: 'Nirvana Cafe', isActive: true),
          ProfileEstablishmentSnapshot(name: 'Olaya Branch', isActive: true),
        ],
      ),
      locale: const Locale('en'),
    );
    final switchButton = find.text(
      'Create or switch another establishment / branch',
    );
    await tester.scrollUntilVisible(switchButton, 300);
    await tester.drag(find.byType(ListView), const Offset(0, -160));
    await tester.pumpAndSettle();
    await tester.tap(switchButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Olaya Branch'));
    await tester.pumpAndSettle();
    expect(find.text('Olaya Branch'), findsOneWidget);
    expect(find.text('Nirvana Cafe'), findsNothing);
  });

  testWidgets('asks to retry when the profile is missing', (tester) async {
    await _pumpProfile(tester, profile: null, locale: const Locale('en'));
    expect(find.text("We couldn't load your profile"), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('arabic profile layout fits the screen', (tester) async {
    await _pumpProfile(tester, profile: _profile(), locale: const Locale('ar'));
    expect(find.text('مالك منشأة'), findsOneWidget);
    expect(find.text('قائمة وتعمل'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.text('إعدادات الحساب'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpProfile(
  WidgetTester tester, {
  required ProfileSnapshot? profile,
  required Locale locale,
}) async {
  SharedPreferences.setMockInitialValues({});
  await locator.reset();
  locator.registerFactory<ProfileCubit>(
    () => ProfileCubit(_MockProfileRepo(profile: profile)),
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
            return MaterialApp(
              locale: locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const ProfileScreen(),
            );
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

ProfileSnapshot _profile({List<ProfileEstablishmentSnapshot>? establishments}) {
  return ProfileSnapshot(
    name: 'Abdullah Al Saeed',
    role: 'owner',
    phone: '+966 50 123 4567',
    email: 'abdullah@foodsolutions.sa',
    initials: 'AS',
    phoneVerifiedAt: '2024-01-01T00:00:00Z',
    establishments:
        establishments ??
        const [
          ProfileEstablishmentSnapshot(
            name: 'Nirvana Cafe',
            headquarters: 'Riyadh',
            activity: 'Bakeries',
            ageInMonths: 24,
            isActive: true,
          ),
        ],
  );
}

class _MockProfileRepo implements ProfileRepo {
  final ProfileSnapshot? profile;

  _MockProfileRepo({required this.profile});

  @override
  ProfileSnapshot? readProfile() => profile;
}
