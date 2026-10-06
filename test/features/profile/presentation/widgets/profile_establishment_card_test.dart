import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_establishment_card.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_location_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await AppTranslations().setLocale(const Locale('en'));
  });

  testWidgets('shows a location button when a location action is provided', (
    tester,
  ) async {
    var actualOpened = false;
    await _pumpCard(
      tester,
      establishment: const ProfileEstablishmentSnapshot(
        name: 'مقهى ومطعم الأفق',
        isActive: true,
        location: 'https://maps.google.com/?q=24.7136,46.6753',
      ),
      onOpenLocation: () => actualOpened = true,
    );
    expect(find.byType(ProfileLocationButton), findsOneWidget);
    expect(find.text('Open location'), findsOneWidget);
    await tester.tap(find.byType(ProfileLocationButton));
    await tester.pump();
    expect(actualOpened, isTrue);
  });

  testWidgets('hides the location button when there is no location action', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      establishment: const ProfileEstablishmentSnapshot(
        name: 'test',
        isActive: true,
      ),
    );
    expect(find.byType(ProfileLocationButton), findsNothing);
    expect(find.text('Open location'), findsNothing);
  });
}

Future<void> _pumpCard(
  WidgetTester tester, {
  required ProfileEstablishmentSnapshot establishment,
  VoidCallback? onOpenLocation,
}) async {
  final translations = await AppTranslations.init(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'ar'],
  );
  await translations.setLocale(const Locale('en'));
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(375, 812);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    LocalizedApp(
      translations,
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) {
          return MaterialApp(
            home: Scaffold(
              body: ProfileEstablishmentCard(
                establishment: establishment,
                onOpenLocation: onOpenLocation,
                onSwitchBranch: () {},
              ),
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}
