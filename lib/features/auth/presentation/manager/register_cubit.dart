import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/register_state.dart';

const int _minimumPasswordLength = 8;
final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepo _authRepo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RegisterCubit(this._authRepo) : super(const RegisterInitial());

  bool get canSubmit {
    return validateName(nameController.text) == null &&
        validatePhone(phoneController.text) == null &&
        validateEmail(emailController.text) == null &&
        validatePassword(passwordController.text) == null &&
        validateConfirmPassword(confirmPasswordController.text) == null;
  }

  String? validateName(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return translate('booking_validation_required');
    return null;
  }

  String? validatePhone(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return translate('booking_validation_required');
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) return translate('booking_validation_phone');
    return null;
  }

  String? validateEmail(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return translate('booking_validation_required');
    if (!_emailPattern.hasMatch(input)) {
      return translate('booking_validation_email');
    }
    return null;
  }

  String? validatePassword(String? value) {
    final input = value ?? '';
    if (input.isEmpty) return translate('booking_validation_required');
    if (input.length < _minimumPasswordLength) {
      return translate('register_validation_password');
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    final input = value ?? '';
    if (input.isEmpty) return translate('booking_validation_required');
    if (input != passwordController.text) {
      return translate('register_validation_password_mismatch');
    }
    return null;
  }

  Future<void> sendRegistrationOtp() async {
    if (state is RegisterLoading) return;
    if (!canSubmit) {
      emit(
        RegisterFailure(
          message: translate('validationError'),
          status: ApiFailureStatus.validation,
        ),
      );
      return;
    }
    emit(const RegisterLoading());
    final result = await _authRepo.sendOtp(
      SendOtpRequestModel(identifier: emailController.text.trim()),
    );
    result.fold(_emitFailure, _emitOtpSent);
  }

  void _emitFailure(ServerFailure failure) {
    emit(
      RegisterFailure(
        message: failure.message,
        status: failure.status,
        statusCode: failure.statusCode,
      ),
    );
  }

  void _emitOtpSent(SendOtpResponseModel response) {
    emit(RegisterOtpSent(response: response));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
