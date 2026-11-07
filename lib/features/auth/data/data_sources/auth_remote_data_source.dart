import 'package:food_solutions/core/services/api_service.dart';
import 'package:food_solutions/core/utils/endpoint.dart';
import 'package:food_solutions/features/auth/data/models/login_request_model.dart';
import 'package:food_solutions/features/auth/data/models/register_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> sendOtp(SendOtpRequestModel request);

  Future<Map<String, dynamic>> verifyOtp(VerifyOtpRequestModel request);

  Future<Map<String, dynamic>> login(LoginRequestModel request);

  Future<Map<String, dynamic>> register(RegisterRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<Map<String, dynamic>> sendOtp(SendOtpRequestModel request) {
    return _apiService.post(endPoint: Endpoint.sendOtp, data: request.toJson());
  }

  @override
  Future<Map<String, dynamic>> verifyOtp(VerifyOtpRequestModel request) {
    return _apiService.post(
      endPoint: Endpoint.verifyOtp,
      data: request.toJson(),
    );
  }

  @override
  Future<Map<String, dynamic>> login(LoginRequestModel request) {
    return _apiService.post(endPoint: Endpoint.login, data: request.toJson());
  }

  @override
  Future<Map<String, dynamic>> register(RegisterRequestModel request) {
    return _apiService.post(
      endPoint: Endpoint.register,
      data: request.toJson(),
    );
  }
}
