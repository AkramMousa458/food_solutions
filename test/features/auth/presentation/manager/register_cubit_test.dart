import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
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
    await cubit.sendRegistrationOtp();
    expect(mockAuthRepo.callCount, 0);
    expect(cubit.state, isA<RegisterFailure>());
    final actualState = cubit.state as RegisterFailure;
    expect(actualState.status, ApiFailureStatus.validation);
    expect(actualState.message, translate('validationError'));
  });

  test('sends an email otp and emits the response', () async {
    _fillValidForm(cubit);
    final expectedResponse = SendOtpResponseModel(
      isSuccess: true,
      message: 'تم إرسال رمز التحقق إلى بريدك الإلكتروني (Gmail) بنجاح.',
      identifier: 'akrammousa458@gmail.com',
      type: 'email',
      expiresAt: DateTime.parse('2026-10-04T22:28:50+00:00'),
      code: '510098',
    );
    mockAuthRepo.result = Right(expectedResponse);
    final actualStates = <RegisterState>[];
    final subscription = cubit.stream.listen(actualStates.add);
    await cubit.sendRegistrationOtp();
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();
    expect(mockAuthRepo.callCount, 1);
    expect(mockAuthRepo.lastRequest?.identifier, 'akrammousa458@gmail.com');
    expect(mockAuthRepo.lastRequest?.type, SendOtpRequestModel.emailType);
    expect(actualStates, <RegisterState>[
      const RegisterLoading(),
      RegisterOtpSent(response: expectedResponse),
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
    await cubit.sendRegistrationOtp();
    final actualState = cubit.state as RegisterFailure;
    expect(actualState.status, ApiFailureStatus.tooManyRequests);
    expect(actualState.statusCode, 429);
    expect(actualState.message, 'محاولات كثيرة. يرجى المحاولة لاحقاً.');
  });

  test('ignores a second submit while the request is loading', () async {
    _fillValidForm(cubit);
    mockAuthRepo.pending =
        Completer<Either<ServerFailure, SendOtpResponseModel>>();
    final firstCall = cubit.sendRegistrationOtp();
    final secondCall = cubit.sendRegistrationOtp();
    expect(mockAuthRepo.callCount, 1);
    expect(cubit.state, isA<RegisterLoading>());
    mockAuthRepo.pending!.complete(
      Right(
        const SendOtpResponseModel(
          isSuccess: true,
          message: 'sent',
          identifier: 'akrammousa458@gmail.com',
          type: 'email',
        ),
      ),
    );
    await firstCall;
    await secondCall;
    expect(mockAuthRepo.callCount, 1);
    expect(cubit.state, isA<RegisterOtpSent>());
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
  SendOtpRequestModel? lastRequest;
  Either<ServerFailure, SendOtpResponseModel> result = Left(
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
