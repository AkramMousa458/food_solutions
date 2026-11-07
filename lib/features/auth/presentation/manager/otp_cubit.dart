import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_state.dart';

final RegExp _otpCodePattern = RegExp(r'^\d{6}$');

class OtpCubit extends Cubit<OtpState> {
  static const int codeLength = 6;

  final AuthRepo _authRepo;

  OtpCubit(this._authRepo) : super(const OtpInitial());

  bool get isBusy => state is OtpVerifying || state is OtpResending;

  void clearStatus() {
    if (state is OtpFailure || state is OtpResent) {
      emit(const OtpInitial());
    }
  }

  Future<void> verifyOtp({
    required String identifier,
    required String code,
  }) async {
    if (isBusy) return;
    final normalizedIdentifier = identifier.trim();
    final normalizedCode = code.trim();
    if (normalizedIdentifier.isEmpty ||
        !_otpCodePattern.hasMatch(normalizedCode)) {
      emit(
        OtpFailure(
          message: translate('otp_invalid_code'),
          status: ApiFailureStatus.validation,
        ),
      );
      return;
    }
    emit(const OtpVerifying());
    final result = await _authRepo.verifyOtp(
      VerifyOtpRequestModel(
        identifier: normalizedIdentifier,
        code: normalizedCode,
      ),
    );
    result.fold(_emitFailure, _emitVerified);
  }

  Future<void> resendOtp({required String identifier}) async {
    if (isBusy) return;
    final normalizedIdentifier = identifier.trim();
    if (normalizedIdentifier.isEmpty) {
      emit(
        OtpFailure(
          message: translate('unexpectedError'),
          status: ApiFailureStatus.validation,
        ),
      );
      return;
    }
    emit(const OtpResending());
    final result = await _authRepo.sendOtp(
      SendOtpRequestModel(identifier: normalizedIdentifier),
    );
    result.fold(_emitFailure, _emitResent);
  }

  void _emitFailure(ServerFailure failure) {
    emit(
      OtpFailure(
        message: failure.message,
        status: failure.status,
        statusCode: failure.statusCode,
      ),
    );
  }

  void _emitVerified(VerifyOtpResponseModel response) {
    emit(OtpVerified(response: response));
  }

  void _emitResent(SendOtpResponseModel response) {
    final message = response.message.trim();
    emit(
      OtpResent(
        message: message.isEmpty ? translate('otp_resend_sent') : message,
      ),
    );
  }
}
