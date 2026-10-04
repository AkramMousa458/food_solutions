import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/auth/data/models/login_request_model.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/login_state.dart';

final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo _authRepo;
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginCubit(this._authRepo) : super(const LoginInitial());

  bool get canSubmit {
    return validateIdentifier(identifierController.text) == null &&
        validatePassword(passwordController.text) == null;
  }

  String? validateIdentifier(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return translate('booking_validation_required');
    if (input.contains('@')) {
      if (!_emailPattern.hasMatch(input)) {
        return translate('booking_validation_email');
      }
      return null;
    }
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) return translate('login_identifier_invalid');
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return translate('booking_validation_required');
    }
    return null;
  }

  Future<void> login() async {
    if (state is LoginLoading) return;
    if (!canSubmit) {
      emit(
        LoginFailure(
          message: translate('validationError'),
          status: ApiFailureStatus.validation,
        ),
      );
      return;
    }
    emit(const LoginLoading());
    final result = await _authRepo.login(
      LoginRequestModel(
        emailOrPhone: identifierController.text.trim(),
        password: passwordController.text,
      ),
    );
    result.fold(_emitFailure, _emitSuccess);
  }

  void _emitFailure(ServerFailure failure) {
    emit(
      LoginFailure(
        message: failure.message,
        status: failure.status,
        statusCode: failure.statusCode,
      ),
    );
  }

  void _emitSuccess(LoginResponseModel response) {
    emit(LoginSuccess(user: response.user));
  }

  @override
  Future<void> close() {
    identifierController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
