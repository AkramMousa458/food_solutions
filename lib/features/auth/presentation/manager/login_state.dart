import 'package:equatable/equatable.dart';
import 'package:food_solutions/core/error/failure.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginOtpSent extends LoginState {
  final String phone;

  const LoginOtpSent({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class LoginGuest extends LoginState {
  const LoginGuest();
}

class LoginFailure extends LoginState {
  final String message;
  final ApiFailureStatus status;
  final int? statusCode;

  const LoginFailure({
    required this.message,
    required this.status,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, status, statusCode];
}
