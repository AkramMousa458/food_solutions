import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/auth/data/models/login_request_model.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/auth/data/models/register_request_model.dart';
import 'package:food_solutions/features/auth/data/models/register_response_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/register_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/register_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockAuthRepo mockAuthRepo;
  late RegisterCubit cubit;

  setUp(() {
    mockAuthRepo = _MockAuthRepo();
    cubit = RegisterCubit(mockAuthRepo);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('rejects empty and invalid register fields', () {
    expect(cubit.validateName(' '), translate('booking_validation_required'));
    expect(cubit.validateName('Mohamed Ahmed'), isNull);
    expect(cubit.validatePhone('123'), translate('booking_validation_phone'));
    expect(cubit.validatePhone('966501234567'), isNull);
    expect(
      cubit.validateEmail('not-an-email'),
      translate('booking_validation_email'),
    );
    expect(cubit.validateEmail('akrammousa458@gmail.com'), isNull);
    expect(
      cubit.validatePassword('short'),
      translate('register_validation_password'),
    );
    expect(cubit.validatePassword('password1'), isNull);
    cubit.passwordController.text = 'password1';
    expect(
      cubit.validateConfirmPassword('password2'),
      translate('register_validation_password_mismatch'),
    );
    expect(cubit.validateConfirmPassword('password1'), isNull);
  });

  test('does not call the api when the form is incomplete', () async {
    expect(cubit.canSubmit, isFalse);
    await cubit.register();
    expect(mockAuthRepo.callCount, 0);
    expect(cubit.state, isA<RegisterFailure>());
    final actualState = cubit.state as RegisterFailure;
    expect(actualState.status, ApiFailureStatus.validation);
    expect(actualState.message, translate('validationError'));
  });

  test('registers the account and emits the response', () async {
    _fillValidForm(cubit);
    const expectedResponse = RegisterResponseModel(
      isSuccess: true,
      message:
          'تم إنشاء الحساب بنجاح. يرجى تفعيل الحساب باستخدام رمز التحقق (OTP) المرسل إليك.',
      requiresVerification: true,
      identifier: 'akrammousa458@gmail.com',
    );
    mockAuthRepo.result = const Right(expectedResponse);
    final actualStates = <RegisterState>[];
    final subscription = cubit.stream.listen(actualStates.add);
    await cubit.register();
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();
    expect(mockAuthRepo.callCount, 1);
    expect(mockAuthRepo.lastRequest?.name, 'Mohamed Ahmed');
    expect(mockAuthRepo.lastRequest?.phone, '966501234567');
    expect(mockAuthRepo.lastRequest?.email, 'akrammousa458@gmail.com');
    expect(mockAuthRepo.lastRequest?.password, 'password1');
    expect(mockAuthRepo.lastRequest?.passwordConfirmation, 'password1');
    expect(actualStates, <RegisterState>[
      const RegisterLoading(),
      const RegisterSuccess(response: expectedResponse),
    ]);
  });

  test('emits the api failure status', () async {
    _fillValidForm(cubit);
    mockAuthRepo.result = Left(
      ServerFailure(
        message: 'محاولات كثيرة. يرجى المحاولة لاحقاً.',
        status: ApiFailureStatus.tooManyRequests,
        statusCode: 429,
      ),
    );
    await cubit.register();
    final actualState = cubit.state as RegisterFailure;
    expect(actualState.status, ApiFailureStatus.tooManyRequests);
    expect(actualState.statusCode, 429);
    expect(actualState.message, 'محاولات كثيرة. يرجى المحاولة لاحقاً.');
  });

  test('ignores a second submit while the request is loading', () async {
    _fillValidForm(cubit);
    mockAuthRepo.pending =
        Completer<Either<ServerFailure, RegisterResponseModel>>();
    final firstCall = cubit.register();
    final secondCall = cubit.register();
    expect(mockAuthRepo.callCount, 1);
    expect(cubit.state, isA<RegisterLoading>());
    mockAuthRepo.pending!.complete(
      const Right(
        RegisterResponseModel(
          isSuccess: true,
          message: 'sent',
          requiresVerification: true,
          identifier: 'akrammousa458@gmail.com',
        ),
      ),
    );
    await firstCall;
    await secondCall;
    expect(mockAuthRepo.callCount, 1);
    expect(cubit.state, isA<RegisterSuccess>());
  });
}

void _fillValidForm(RegisterCubit cubit) {
  cubit.nameController.text = 'Mohamed Ahmed';
  cubit.phoneController.text = '966501234567';
  cubit.emailController.text = ' akrammousa458@gmail.com ';
  cubit.passwordController.text = 'password1';
  cubit.confirmPasswordController.text = 'password1';
}

class _MockAuthRepo implements AuthRepo {
  int callCount = 0;
  RegisterRequestModel? lastRequest;
  Either<ServerFailure, RegisterResponseModel> result = const Left(
    ServerFailure(message: 'failed', status: ApiFailureStatus.unexpected),
  );
  Completer<Either<ServerFailure, RegisterResponseModel>>? pending;

  @override
  Future<Either<ServerFailure, RegisterResponseModel>> register(
    RegisterRequestModel request,
  ) {
    callCount += 1;
    lastRequest = request;
    final completer = pending;
    if (completer != null) return completer.future;
    return Future<Either<ServerFailure, RegisterResponseModel>>.value(result);
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
  Future<Either<ServerFailure, LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    throw UnimplementedError();
  }
}
