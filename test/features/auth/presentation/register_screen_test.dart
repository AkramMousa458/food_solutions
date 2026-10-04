import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/core/utils/service_locator.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/register_cubit.dart';
import 'package:food_solutions/features/auth/presentation/screens/otp_screen.dart';
import 'package:food_solutions/features/auth/presentation/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppTranslations translations;
  late _MockAuthRepo mockAuthRepo;

  setUp(() async {
    await locator.reset();
    mockAuthRepo = _MockAuthRepo();
    locator.registerFactory<RegisterCubit>(() => RegisterCubit(mockAuthRepo));
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

  testWidgets('shows field errors and does not send otp', (tester) async {
    await _pumpRegisterScreen(tester, translations);
    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.text('This field is required'), findsWidgets);
    expect(mockAuthRepo.callCount, 0);
  });

  testWidgets('sends the email otp and shows the api message', (tester) async {
    const inputMessage = 'Verification code sent.';
    mockAuthRepo.pending =
        Completer<Either<ServerFailure, SendOtpResponseModel>>();
    await _pumpRegisterScreen(tester, translations);
    await _enterValidForm(tester);
    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(mockAuthRepo.lastRequest?.identifier, 'akrammousa458@gmail.com');
    expect(mockAuthRepo.lastRequest?.type, 'email');
    mockAuthRepo.pending!.complete(
      const Right(
        SendOtpResponseModel(
          isSuccess: true,
          message: inputMessage,
          identifier: 'akrammousa458@gmail.com',
          type: 'email',
          code: '510098',
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Verify code'), findsOneWidget);
    expect(find.text(inputMessage), findsOneWidget);
    expect(find.text('510098'), findsNothing);
  });

  testWidgets('shows the api error message', (tester) async {
    const inputMessage = 'Email is already used';
    mockAuthRepo.result = const Left(
      ServerFailure(
        message: inputMessage,
        status: ApiFailureStatus.conflict,
        statusCode: 409,
      ),
    );
    await _pumpRegisterScreen(tester, translations);
    await _enterValidForm(tester);
    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump();
    expect(find.text(inputMessage), findsOneWidget);
  });
}

Future<void> _pumpRegisterScreen(
  WidgetTester tester,
  AppTranslations translations,
) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(375, 812);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  final router = _registerRouter();
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
}

Future<void> _enterValidForm(WidgetTester tester) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'Mohamed Ahmed');
  await tester.enterText(fields.at(1), '966501234567');
  await tester.enterText(fields.at(2), 'akrammousa458@gmail.com');
  await tester.enterText(fields.at(3), 'password1');
  await tester.enterText(fields.at(4), 'password1');
  await tester.pump();
}

GoRouter _registerRouter() {
  final router = GoRouter(
    initialLocation: RegisterScreen.routeName,
    routes: [
      GoRoute(
        path: RegisterScreen.routeName,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: OtpScreen.routeName,
        builder: (context, state) {
          final extra = state.extra;
          final identifier = extra is String ? extra : '';
          return OtpScreen(identifier: identifier);
        },
      ),
    ],
  );
  addTearDown(router.dispose);
  return router;
}

class _MockAuthRepo implements AuthRepo {
  int callCount = 0;
  SendOtpRequestModel? lastRequest;
  Either<ServerFailure, SendOtpResponseModel> result = const Left(
    ServerFailure(message: 'failed', status: ApiFailureStatus.unexpected),
  );
  Completer<Either<ServerFailure, SendOtpResponseModel>>? pending;

  @override
  Future<Either<ServerFailure, SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  ) {
    callCount += 1;
    lastRequest = request;
    final completer = pending;
    if (completer != null) return completer.future;
    return Future<Either<ServerFailure, SendOtpResponseModel>>.value(result);
  }

  @override
  Future<Either<ServerFailure, VerifyOtpResponseModel>> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    throw UnimplementedError();
  }
}
