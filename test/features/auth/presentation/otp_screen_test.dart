import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/theme/theme_light.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_cubit.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/auth/presentation/screens/otp_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppTranslations translations;
  late _MockAuthRepo mockAuthRepo;

  setUp(() async {
    await locator.reset();
    mockAuthRepo = _MockAuthRepo();
    locator.registerFactory<OtpCubit>(() => OtpCubit(mockAuthRepo));
    translations = await AppTranslations.init(
      fallbackLocale: 'en',
      supportedLocales: ['en', 'ar'],
    );
    await translations.setLocale(const Locale('en'));
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('shows six digit boxes for the email', (tester) async {
    await _pumpOtpScreen(tester, translations);
    expect(find.text('Verify code'), findsOneWidget);
    expect(find.text(inputIdentifier), findsOneWidget);
    for (var index = 0; index < 6; index++) {
      expect(find.byKey(ValueKey('otp_digit_$index')), findsOneWidget);
    }
    final firstBox = tester.getRect(find.byKey(const ValueKey('otp_digit_0')));
    final secondBox = tester.getRect(find.byKey(const ValueKey('otp_digit_1')));
    final field = tester.getRect(find.byType(TextField));
    expect(firstBox.height, greaterThan(40));
    expect(firstBox.width, greaterThan(28));
    expect(secondBox.left, greaterThan(firstBox.right - 1));
    expect(field.height, lessThanOrEqualTo(firstBox.height + 1));
    expect(field.top, greaterThanOrEqualTo(firstBox.top - 1));
  });

  testWidgets('asks for six digits before calling verify', (tester) async {
    await _pumpOtpScreen(tester, translations);
    await tester.enterText(find.byType(TextField), '90357');
    await tester.pump();
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Verify'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
    await tester.pump();
    expect(mockAuthRepo.verifyCallCount, 0);
    expect(find.text('Enter the 6-digit code'), findsAtLeast(1));
  });

  testWidgets('shows the invalid otp message from the api', (tester) async {
    const inputMessage = 'رمز التحقق غير صحيح أو منتهي الصلاحية.';
    mockAuthRepo.verifyResult = const Left(
      ServerFailure(
        message: inputMessage,
        status: ApiFailureStatus.validation,
        statusCode: 422,
      ),
    );
    await _pumpOtpScreen(tester, translations);
    await tester.enterText(find.byType(TextField), '000000');
    await tester.pump();
    await tester.pump();
    expect(mockAuthRepo.lastVerifyRequest?.identifier, inputIdentifier);
    expect(mockAuthRepo.lastVerifyRequest?.code, '000000');
    expect(find.text(inputMessage), findsAtLeast(1));
  });

  testWidgets('shows the verified state and continues to sign in', (
    tester,
  ) async {
    const inputMessage = 'تم التحقق من الرمز بنجاح.';
    mockAuthRepo.verifyResult = const Right(
      VerifyOtpResponseModel(
        isSuccess: true,
        message: inputMessage,
        isVerified: true,
      ),
    );
    await _pumpOtpScreen(tester, translations);
    await tester.enterText(find.byType(TextField), '903575');
    await tester.pump();
    await tester.pump();
    expect(find.text('Email verified'), findsOneWidget);
    expect(find.text(inputMessage), findsOneWidget);
    await tester.tap(find.text('Continue to sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
  });
}

Future<void> _pumpOtpScreen(
  WidgetTester tester,
  AppTranslations translations,
) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(375, 812);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final router = GoRouter(
    initialLocation: OtpScreen.routeName,
    routes: [
      GoRoute(
        path: OtpScreen.routeName,
        builder: (context, state) =>
            const OtpScreen(identifier: inputIdentifier),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    LocalizedApp(
      translations,
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) {
          return MaterialApp.router(routerConfig: router, theme: lightTheme);
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

const String inputIdentifier = 'mohmedetman955@gmail.com';

class _MockAuthRepo implements AuthRepo {
  int verifyCallCount = 0;
  VerifyOtpRequestModel? lastVerifyRequest;
  Either<ServerFailure, VerifyOtpResponseModel> verifyResult = const Left(
    ServerFailure(message: 'failed', status: ApiFailureStatus.unexpected),
  );

  @override
  Future<Either<ServerFailure, VerifyOtpResponseModel>> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    verifyCallCount += 1;
    lastVerifyRequest = request;
    return verifyResult;
  }

  @override
  Future<Either<ServerFailure, SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  ) async {
    return const Right(
      SendOtpResponseModel(
        isSuccess: true,
        message: 'sent',
        identifier: inputIdentifier,
        type: 'email',
      ),
    );
  }
}
