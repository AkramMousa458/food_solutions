import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_state.dart';

void main() {
  test('resendOtp sends the code as a phone OTP', () async {
    final mockAuthRepo = MockAuthRepo();
    final cubit = OtpCubit(mockAuthRepo);
    const inputIdentifier = '966501234567';
    await cubit.resendOtp(identifier: inputIdentifier);
    final actualRequest = mockAuthRepo.capturedSendRequest;
    final actualState = cubit.state;
    expect(actualRequest?.identifier, inputIdentifier);
    expect(actualRequest?.type, SendOtpRequestModel.phoneType);
    expect(actualState, isA<OtpResent>());
    await cubit.close();
  });
}

class MockAuthRepo implements AuthRepo {
  SendOtpRequestModel? capturedSendRequest;

  @override
  Future<Either<ServerFailure, SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  ) async {
    capturedSendRequest = request;
    return Right(
      SendOtpResponseModel(
        isSuccess: true,
        message: 'sent',
        identifier: request.identifier,
        type: request.type,
      ),
    );
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
