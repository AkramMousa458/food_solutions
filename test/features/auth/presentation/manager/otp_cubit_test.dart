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
import 'package:food_solutions/features/auth/presentation/manager/otp_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockAuthRepo mockAuthRepo;
  late OtpCubit cubit;
  const inputIdentifier = 'mohmedetman955@gmail.com';

  setUp(() {
    mockAuthRepo = _MockAuthRepo();
    cubit = OtpCubit(mockAuthRepo);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('rejects a code that is not 6 digits', () async {
    await cubit.verifyOtp(identifier: inputIdentifier, code: '90357');
    expect(mockAuthRepo.verifyCallCount, 0);
    final actualState = cubit.state as OtpFailure;
    expect(actualState.status, ApiFailureStatus.validation);
    expect(actualState.message, translate('otp_invalid_code'));
  });

  test('verifies the identifier and code', () async {
    const expectedResponse = VerifyOtpResponseModel(
      isSuccess: true,
      message: 'تم التحقق من الرمز بنجاح.',
      isVerified: true,
    );
    mockAuthRepo.verifyResult = const Right(expectedResponse);
    await cubit.verifyOtp(identifier: ' $inputIdentifier ', code: '903575');
    expect(mockAuthRepo.verifyCallCount, 1);
    expect(mockAuthRepo.lastVerifyRequest?.identifier, inputIdentifier);
    expect(mockAuthRepo.lastVerifyRequest?.code, '903575');
    expect(cubit.state, const OtpVerified(response: expectedResponse));
  });

  test('emits the invalid code message from the api', () async {
    const inputMessage = 'رمز التحقق غير صحيح أو منتهي الصلاحية.';
    mockAuthRepo.verifyResult = const Left(
      ServerFailure(
        message: inputMessage,
        status: ApiFailureStatus.validation,
        statusCode: 422,
      ),
    );
    await cubit.verifyOtp(identifier: inputIdentifier, code: '000000');
    final actualState = cubit.state as OtpFailure;
    expect(actualState.message, inputMessage);
    expect(actualState.statusCode, 422);
  });

  test('resends the otp to the same identifier', () async {
    mockAuthRepo.sendResult = const Right(
      SendOtpResponseModel(
        isSuccess: true,
        message: 'تم إرسال رمز التحقق إلى بريدك الإلكتروني (Gmail) بنجاح.',
        identifier: inputIdentifier,
        type: 'email',
      ),
    );
    await cubit.resendOtp(identifier: inputIdentifier);
    expect(mockAuthRepo.lastSendRequest?.identifier, inputIdentifier);
    expect(mockAuthRepo.lastSendRequest?.type, SendOtpRequestModel.emailType);
    expect(
      cubit.state,
      const OtpResent(
        message: 'تم إرسال رمز التحقق إلى بريدك الإلكتروني (Gmail) بنجاح.',
      ),
    );
  });

  test('ignores a second verify while the first is loading', () async {
    mockAuthRepo.pendingVerify =
        Completer<Either<ServerFailure, VerifyOtpResponseModel>>();
    final firstCall = cubit.verifyOtp(
      identifier: inputIdentifier,
      code: '903575',
    );
    final secondCall = cubit.verifyOtp(
      identifier: inputIdentifier,
      code: '903575',
    );
    expect(mockAuthRepo.verifyCallCount, 1);
    expect(cubit.state, isA<OtpVerifying>());
    mockAuthRepo.pendingVerify!.complete(
      const Right(
        VerifyOtpResponseModel(
          isSuccess: true,
          message: 'تم التحقق من الرمز بنجاح.',
          isVerified: true,
        ),
      ),
    );
    await firstCall;
    await secondCall;
    expect(mockAuthRepo.verifyCallCount, 1);
    expect(cubit.state, isA<OtpVerified>());
  });

  test('clears a visible failure when editing restarts', () async {
    await cubit.verifyOtp(identifier: inputIdentifier, code: '12');
    expect(cubit.state, isA<OtpFailure>());
    cubit.clearStatus();
    expect(cubit.state, const OtpInitial());
    expect(cubit.isBusy, isFalse);
  });
}

class _MockAuthRepo implements AuthRepo {
  int verifyCallCount = 0;
  VerifyOtpRequestModel? lastVerifyRequest;
  SendOtpRequestModel? lastSendRequest;
  Either<ServerFailure, VerifyOtpResponseModel> verifyResult = const Left(
    ServerFailure(message: 'failed', status: ApiFailureStatus.unexpected),
  );
  Either<ServerFailure, SendOtpResponseModel> sendResult = const Left(
    ServerFailure(message: 'failed', status: ApiFailureStatus.unexpected),
  );
  Completer<Either<ServerFailure, VerifyOtpResponseModel>>? pendingVerify;

  @override
  Future<Either<ServerFailure, VerifyOtpResponseModel>> verifyOtp(
    VerifyOtpRequestModel request,
  ) {
    verifyCallCount += 1;
    lastVerifyRequest = request;
    final completer = pendingVerify;
    if (completer != null) return completer.future;
    return Future<Either<ServerFailure, VerifyOtpResponseModel>>.value(
      verifyResult,
    );
  }

  @override
  Future<Either<ServerFailure, SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  ) async {
    lastSendRequest = request;
    return sendResult;
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
