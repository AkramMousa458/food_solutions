import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
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
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/base/presentation/screens/base_screen.dart';
import 'package:food_solutions/features/splash/presentation/manager/splash_cubit.dart';
import 'package:food_solutions/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await locator.reset();
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('opens home when a token is saved', (tester) async {
    locator.registerFactory<SplashCubit>(
      () => SplashCubit(_MockAuthRepo(isAuthenticated: true)),
    );
    await _pumpSplash(tester);
    await tester.pump(splashNavigationDelay);
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('opens login when no token is saved', (tester) async {
    locator.registerFactory<SplashCubit>(
      () => SplashCubit(_MockAuthRepo(isAuthenticated: false)),
    );
    await _pumpSplash(tester);
    await tester.pump(splashNavigationDelay);
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
  });
}

Future<void> _pumpSplash(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(375, 812);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final router = GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const Scaffold(body: Text('Welcome')),
      ),
      GoRoute(
        path: BaseScreen.routeName,
        builder: (context, state) => const Scaffold(body: Text('Home')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, _) => MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pump();
}

class _MockAuthRepo implements AuthRepo {
  final bool isAuthenticated;

  _MockAuthRepo({required this.isAuthenticated});

  @override
  bool hasAuthToken() => isAuthenticated;

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
}
