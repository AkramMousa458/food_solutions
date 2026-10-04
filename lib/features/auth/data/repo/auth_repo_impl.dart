import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepoImpl(this._remoteDataSource);

  @override
  Future<Either<ServerFailure, SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  ) async {
    try {
      final response = await _remoteDataSource.sendOtp(request);
      return _mapResponse(response);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (_) {
      return Left(_unexpectedFailure());
    }
  }

  @override
  Future<Either<ServerFailure, VerifyOtpResponseModel>> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    try {
      final response = await _remoteDataSource.verifyOtp(request);
      return _mapVerifyResponse(response);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (_) {
      return Left(_unexpectedFailure());
    }
  }

  Either<ServerFailure, VerifyOtpResponseModel> _mapVerifyResponse(
    Map<String, dynamic> response,
  ) {
    final model = VerifyOtpResponseModel.fromJson(response);
    if (model.isSuccess && model.isVerified) return Right(model);
    final message = model.message.trim();
    return Left(
      ServerFailure(
        message: message.isEmpty ? ApiErrorMessages.unexpectedError : message,
        status: ApiFailureStatus.unsuccessful,
        data: response,
      ),
    );
  }

  Either<ServerFailure, SendOtpResponseModel> _mapResponse(
    Map<String, dynamic> response,
  ) {
    final model = SendOtpResponseModel.fromJson(response);
    if (model.isSuccess) return Right(model);
    final message = model.message.trim();
    return Left(
      ServerFailure(
        message: message.isEmpty ? ApiErrorMessages.unexpectedError : message,
        status: ApiFailureStatus.unsuccessful,
        data: response,
      ),
    );
  }
}

ServerFailure _unexpectedFailure() {
  return ServerFailure(
    message: ApiErrorMessages.unexpectedError,
    status: ApiFailureStatus.unexpected,
  );
}
