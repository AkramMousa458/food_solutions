import 'package:dartz/dartz.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/models/login_request_model.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/auth/data/models/register_request_model.dart';
import 'package:food_solutions/features/auth/data/models/register_response_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';

abstract class AuthRepo {
  Future<Either<ServerFailure, SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  );

  Future<Either<ServerFailure, VerifyOtpResponseModel>> verifyOtp(
    VerifyOtpRequestModel request,
  );

  Future<Either<ServerFailure, LoginResponseModel>> login(
    LoginRequestModel request,
  );

  Future<Either<ServerFailure, RegisterResponseModel>> register(
    RegisterRequestModel request,
  );

  bool hasAuthToken();
}
