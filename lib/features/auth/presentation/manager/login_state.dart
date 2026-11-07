import 'package:equatable/equatable.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/auth/data/models/auth_user_model.dart';

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

class LoginSuccess extends LoginState {
  final AuthUserModel user;

  const LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user.id, user.email, user.name];
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
