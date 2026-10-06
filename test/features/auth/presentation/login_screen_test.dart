import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/assets.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/features/auth/data/models/login_request_model.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/auth/data/models/register_request_model.dart';
import 'package:food_solutions/features/auth/data/models/register_response_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/login_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/register_cubit.dart';
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/auth/presentation/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await locator.reset();
    locator.registerFactory<LoginCubit>(() => LoginCubit(_IdleAuthRepo()));
    locator.registerFactory<RegisterCubit>(
      () => RegisterCubit(_IdleAuthRepo()),
    );
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('opens register from login and returns to sign in', (
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
    final router = GoRouter(
      initialLocation: LoginScreen.routeName,
      routes: [
        GoRoute(
          path: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RegisterScreen.routeName,
          builder: (context, state) => const RegisterScreen(),
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
            return MaterialApp.router(routerConfig: router);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.image(const AssetImage(Assets.logo)), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('966501234567'), findsOneWidget);
    expect(find.text('admin@admin.com'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
  });
}

class _IdleAuthRepo implements AuthRepo {
  @override
  Future<Either<ServerFailure, SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerFailure, VerifyOtpResponseModel>> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerFailure, LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerFailure, RegisterResponseModel>> register(
    RegisterRequestModel request,
  ) async {
    throw UnimplementedError();
  }

  @override
  bool hasAuthToken() => false;
}
