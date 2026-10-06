import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/models/login_request_model.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/auth/data/models/register_request_model.dart';
import 'package:food_solutions/features/auth/data/models/register_response_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/splash/presentation/manager/splash_cubit.dart';
import 'package:food_solutions/features/splash/presentation/manager/splash_state.dart';

void main() {
  test('opens home when a token is saved', () async {
    final cubit = SplashCubit(_MockAuthRepo(isAuthenticated: true));
    addTearDown(cubit.close);
    cubit.resolveSession();
    expect(cubit.state, const SplashAuthenticated());
  });

  test('opens login when no token is saved', () async {
    final cubit = SplashCubit(_MockAuthRepo(isAuthenticated: false));
    addTearDown(cubit.close);
    cubit.resolveSession();
    expect(cubit.state, const SplashUnauthenticated());
  });
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
