import 'package:equatable/equatable.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/models/register_response_model.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final RegisterResponseModel response;

  const RegisterSuccess({required this.response});

  @override
  List<Object?> get props => [
    response.isSuccess,
    response.message,
    response.requiresVerification,
    response.identifier,
    response.user?.id,
  ];
}

class RegisterFailure extends RegisterState {
  final String message;
  final ApiFailureStatus status;
  final int? statusCode;

  const RegisterFailure({
    required this.message,
    required this.status,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, status, statusCode];
}
