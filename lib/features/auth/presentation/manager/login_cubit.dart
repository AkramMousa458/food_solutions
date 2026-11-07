import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo _authRepo;
  final TextEditingController phoneController = TextEditingController();

  LoginCubit(this._authRepo) : super(const LoginInitial());

  bool get canSubmit => validatePhone(phoneController.text) == null;

  String? validatePhone(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return translate('booking_validation_required');
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) return translate('login_identifier_invalid');
    return null;
  }

  Future<void> continueAsGuest() async {
    if (state is LoginLoading) return;
    await _authRepo.enterGuestMode();
    emit(const LoginGuest());
  }

  Future<void> sendOtp() async {
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
    final phone = phoneController.text.trim();
    final result = await _authRepo.sendOtp(
      SendOtpRequestModel(
        identifier: phone,
        type: SendOtpRequestModel.phoneType,
      ),
    );
    result.fold(_emitFailure, (response) => _emitOtpSent(phone, response));
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

  void _emitOtpSent(String phone, SendOtpResponseModel response) {
    final identifier = response.identifier.trim();
    emit(LoginOtpSent(phone: identifier.isEmpty ? phone : identifier));
  }

  @override
  Future<void> close() {
    phoneController.dispose();
    return super.close();
  }
}
