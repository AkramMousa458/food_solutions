import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/theme/theme_light.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/features/auth/data/models/auth_user_model.dart';
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
import 'package:food_solutions/features/auth/presentation/screens/login_screen.dart';
import 'package:food_solutions/features/base/presentation/screens/base_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppTranslations translations;
  late _MockAuthRepo mockAuthRepo;

  setUp(() async {
    await locator.reset();
    mockAuthRepo = _MockAuthRepo();
    locator.registerFactory<LoginCubit>(() => LoginCubit(mockAuthRepo));
    translations = await AppTranslations.init(
      fallbackLocale: 'en',
      supportedLocales: ['en', 'ar'],
    );
    await translations.setLocale(const Locale('en'));
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('shows the invalid credentials message', (tester) async {
    const inputMessage = 'بيانات الدخول غير صحيحة.';
    mockAuthRepo.loginResult = const Left(
      ServerFailure(
        message: inputMessage,
        status: ApiFailureStatus.validation,
        statusCode: 422,
      ),
    );
    await _pumpLoginScreen(tester, translations);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'akrammousa458@gmail.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), '12345678');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pump();
    await tester.pump();
    expect(mockAuthRepo.lastRequest?.emailOrPhone, 'akrammousa458@gmail.com');
    expect(mockAuthRepo.lastRequest?.password, '12345678');
    expect(find.text(inputMessage), findsAtLeast(1));
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('opens the app after a successful login', (tester) async {
    mockAuthRepo.loginResult = const Right(
      LoginResponseModel(
        token: '4|session-token',
        user: AuthUserModel(
          id: 4,
          name: 'محمد أحمد',
          email: 'mohmedetman955@gmail.com',
          phone: '0101255874141',
          role: 'client',
          establishments: [],
        ),
      ),
    );
    await _pumpLoginScreen(tester, translations);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'akrammousa458@gmail.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), '12345678');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Continue'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });
}

Future<void> _pumpLoginScreen(
  WidgetTester tester,
  AppTranslations translations,
) async {
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
        path: BaseScreen.routeName,
        builder: (context, state) => const Scaffold(body: Text('Home')),
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

class _MockAuthRepo implements AuthRepo {
  LoginRequestModel? lastRequest;
  Either<ServerFailure, LoginResponseModel> loginResult = const Left(
    ServerFailure(message: 'failed', status: ApiFailureStatus.unexpected),
  );

  @override
  Future<Either<ServerFailure, LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    lastRequest = request;
    return loginResult;
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

  @override
  Future<Either<ServerFailure, RegisterResponseModel>> register(
    RegisterRequestModel request,
  ) async {
    throw UnimplementedError();
  }

  @override
  bool hasAuthToken() => false;
}
