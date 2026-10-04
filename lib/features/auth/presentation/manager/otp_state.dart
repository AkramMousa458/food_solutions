import 'package:equatable/equatable.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object?> get props => [];
}

class OtpInitial extends OtpState {
  const OtpInitial();
}

class OtpVerifying extends OtpState {
  const OtpVerifying();
}

class OtpResending extends OtpState {
  const OtpResending();
}

class OtpVerified extends OtpState {
  final VerifyOtpResponseModel response;

  const OtpVerified({required this.response});

  @override
  List<Object?> get props => [
    response.isSuccess,
    response.isVerified,
    response.message,
    response.user?.id,
    response.token,
  ];
}

class OtpResent extends OtpState {
  final String message;

  const OtpResent({required this.message});

  @override
  List<Object?> get props => [message];
}

class OtpFailure extends OtpState {
  final String message;
  final ApiFailureStatus status;
  final int? statusCode;

  const OtpFailure({
    required this.message,
    required this.status,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, status, statusCode];
}
