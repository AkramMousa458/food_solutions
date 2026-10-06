import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/base/presentation/widgets/custom_bottom_nav_bar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await AppTranslations().setLocale(const Locale('en'));
  });

  testWidgets('opens the profile tab from the bottom navigation', (
    tester,
  ) async {
    final translations = await AppTranslations.init(
      fallbackLocale: 'en',
      supportedLocales: ['en', 'ar'],
    );
    await translations.setLocale(const Locale('en'));
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    var actualIndex = -1;
    await tester.pumpWidget(
      LocalizedApp(
        translations,
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, _) {
            return MaterialApp(
              home: Scaffold(
                bottomNavigationBar: CustomBottomNavBar(
                  selectedIndex: 0,
                  onTap: (index) => actualIndex = index,
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(actualIndex, 6);
    expect(tester.takeException(), isNull);
  });
}
