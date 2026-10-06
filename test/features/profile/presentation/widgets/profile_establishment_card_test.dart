import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/app_colors.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_establishment_card.dart';
import 'package:food_solutions/features/profile/presentation/widgets/profile_establishment_status_chip.dart';
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

  testWidgets('shows edit and delete icons for a saved establishment', (
    tester,
  ) async {
    var actualEdited = false;
    var actualDeleted = false;
    await _pumpCard(
      tester,
      establishment: const ProfileEstablishmentSnapshot(
        id: 7,
        name: 'test',
        isActive: true,
      ),
      onEdit: () => actualEdited = true,
      onDelete: () => actualDeleted = true,
    );
    await tester.tap(find.byKey(const Key('profile-edit-establishment')));
    await tester.tap(find.byKey(const Key('profile-delete-establishment')));
    await tester.pump();
    expect(actualEdited, isTrue);
    expect(actualDeleted, isTrue);
  });

  testWidgets('shows the existing status in the primary color', (tester) async {
    await _pumpCard(
      tester,
      establishment: const ProfileEstablishmentSnapshot(
        name: 'مقهى ومطعم الأفق',
        isActive: true,
        status: 'existing',
      ),
    );
    final actualChip = tester.widget<ProfileEstablishmentStatusChip>(
      find.byType(ProfileEstablishmentStatusChip),
    );
    expect(actualChip.label, 'Existing');
    expect(actualChip.color, AppColors.primary);
  });

  testWidgets('shows under construction in the warning color', (tester) async {
    await _pumpCard(
      tester,
      establishment: const ProfileEstablishmentSnapshot(
        name: 'New Branch',
        isActive: false,
        status: 'under_construction',
      ),
    );
    final actualChip = tester.widget<ProfileEstablishmentStatusChip>(
      find.byType(ProfileEstablishmentStatusChip),
    );
    expect(actualChip.label, 'Under construction');
    expect(actualChip.color, AppColors.warning500);
  });

  testWidgets('shows an idea in the secondary color', (tester) async {
    await _pumpCard(
      tester,
      establishment: const ProfileEstablishmentSnapshot(
        name: 'New Branch',
        isActive: false,
        status: 'idea',
      ),
    );
    final actualChip = tester.widget<ProfileEstablishmentStatusChip>(
      find.byType(ProfileEstablishmentStatusChip),
    );
    expect(actualChip.label, 'Just an idea');
    expect(actualChip.color, AppColors.secondary);
  });

  testWidgets('hides the status chip when the establishment is missing', (
    tester,
  ) async {
    await _pumpCard(tester, establishment: null);
    expect(find.byType(ProfileEstablishmentStatusChip), findsNothing);
  });
}

Future<void> _pumpCard(
  WidgetTester tester, {
  required ProfileEstablishmentSnapshot? establishment,
  VoidCallback? onOpenLocation,
  VoidCallback? onEdit,
  VoidCallback? onDelete,
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
                onEdit: onEdit,
                onDelete: onDelete,
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
