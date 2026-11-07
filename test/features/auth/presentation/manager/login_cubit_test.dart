import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/login_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/login_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepo mockAuthRepo;
  late LoginCubit cubit;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    cubit = LoginCubit(mockAuthRepo);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('validatePhone rejects a number shorter than 9 digits', () {
    const inputPhone = '12345';
    final actualMessage = cubit.validatePhone(inputPhone);
    expect(actualMessage, 'login_identifier_invalid');
  });

  test('sendOtp does not call the repo when the phone is too short', () async {
    const inputPhone = '12345';
    cubit.phoneController.text = inputPhone;
    await cubit.sendOtp();
    final actualState = cubit.state;
    expect(actualState, isA<LoginFailure>());
    expect(mockAuthRepo.sendOtpCallCount, 0);
  });

  test('sendOtp requests a phone code and emits the phone', () async {
    const inputPhone = '966501234567';
    mockAuthRepo.sendOtpResult = const Right(
      SendOtpResponseModel(
        isSuccess: true,
        message: 'sent',
        identifier: inputPhone,
        type: SendOtpRequestModel.phoneType,
      ),
    );
    cubit.phoneController.text = inputPhone;
    await cubit.sendOtp();
    final actualRequest = mockAuthRepo.capturedSendRequest;
    final actualState = cubit.state;
    expect(actualRequest?.identifier, inputPhone);
    expect(actualRequest?.type, SendOtpRequestModel.phoneType);
    expect(actualState, const LoginOtpSent(phone: inputPhone));
  });
}

class MockAuthRepo implements AuthRepo {
  SendOtpRequestModel? capturedSendRequest;
  int sendOtpCallCount = 0;
  Either<ServerFailure, SendOtpResponseModel> sendOtpResult = const Right(
    SendOtpResponseModel(
      isSuccess: true,
      message: '',
      identifier: '',
      type: SendOtpRequestModel.phoneType,
    ),
  );

  @override
  Future<Either<ServerFailure, SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  ) async {
    sendOtpCallCount += 1;
    capturedSendRequest = request;
    return sendOtpResult;
  }

  @override
  Future<Either<ServerFailure, VerifyOtpResponseModel>> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    return const Left(
      ServerFailure(message: 'unused', status: ApiFailureStatus.unexpected),
    );
  }

  @override
  bool hasAuthToken() => false;

  @override
  Future<void> enterGuestMode() async {}

  @override
  bool isGuest() => false;
}
