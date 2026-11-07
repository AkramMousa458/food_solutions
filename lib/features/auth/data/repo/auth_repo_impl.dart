import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_session_data_source.dart';
import 'package:food_solutions/features/auth/data/models/auth_user_model.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthSessionDataSource _sessionDataSource;

  AuthRepoImpl(
    this._remoteDataSource, {
    AuthSessionDataSource? sessionDataSource,
  }) : _sessionDataSource = sessionDataSource ?? _InactiveAuthSession();

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
      final result = _mapVerifyResponse(response);
      return await result.fold(
        (failure) async => Left(failure),
        (model) => _saveVerifiedSession(request, model),
      );
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (_) {
      return Left(_unexpectedFailure());
    }
  }

  Future<Either<ServerFailure, VerifyOtpResponseModel>> _saveVerifiedSession(
    VerifyOtpRequestModel request,
    VerifyOtpResponseModel model,
  ) async {
    final token = model.token?.trim() ?? '';
    final user =
        model.user ??
        AuthUserModel(
          id: 0,
          name: '',
          email: '',
          phone: request.identifier.trim(),
          role: '',
          establishments: const [],
          phoneVerifiedAt: DateTime.now(),
        );
    await _sessionDataSource.saveSession(
      LoginResponseModel(token: token, user: user),
    );
    return Right(model);
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

  @override
  bool hasAuthToken() {
    if (_sessionDataSource.hasPhoneSession()) return true;
    final token = _sessionDataSource.readToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> enterGuestMode() => _sessionDataSource.enterGuestMode();

  @override
  bool isGuest() => _sessionDataSource.isGuest();
}

ServerFailure _unexpectedFailure() {
  return ServerFailure(
    message: ApiErrorMessages.unexpectedError,
    status: ApiFailureStatus.unexpected,
  );
}

class _InactiveAuthSession implements AuthSessionDataSource {
  @override
  Future<void> saveSession(LoginResponseModel session) async {}

  @override
  String? readToken() => null;

  @override
  bool hasPhoneSession() => false;

  @override
  Future<void> clearSession() async {}

  @override
  Future<void> enterGuestMode() async {}

  @override
  bool isGuest() => false;
}
