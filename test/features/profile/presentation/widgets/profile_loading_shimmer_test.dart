import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_loading_shimmer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('lays out the profile loading shimmer', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) {
          return const MaterialApp(home: Scaffold(body: ProfileLoadingShimmer()));
        },
      ),
    );
    await tester.pump();
    expect(find.byType(ProfileLoadingShimmer), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
