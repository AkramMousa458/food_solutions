import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/models/update_profile_request.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/presentation/manager/edit_profile_state.dart';

final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class EditProfileCubit extends Cubit<EditProfileState> {
  final ProfileRepo _profileRepo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  EditProfileCubit(this._profileRepo) : super(const EditProfileReady());

  void prefill(ProfileSnapshot profile) {
    if (state is EditProfileLoading) return;
    nameController.text = profile.name;
    phoneController.text = profile.phone;
    emailController.text = profile.email;
  }

  String? validateName(String? value) => _requireText(value);

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

  bool get canSubmit {
    return validateName(nameController.text) == null &&
        validatePhone(phoneController.text) == null &&
        validateEmail(emailController.text) == null;
  }

  Future<void> updateProfile() async {
    if (state is EditProfileLoading) return;
    if (!canSubmit) {
      emit(
        EditProfileFailure(
          message: translate('validationError'),
          status: ApiFailureStatus.validation,
        ),
      );
      return;
    }
    emit(const EditProfileLoading());
    final result = await _profileRepo.updateAccount(
      UpdateProfileRequest(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
      ),
    );
    result.fold(_emitFailure, _emitUpdated);
  }

  void _emitFailure(ServerFailure failure) {
    emit(
      EditProfileFailure(
        message: failure.message,
        status: failure.status,
        statusCode: failure.statusCode,
      ),
    );
  }

  void _emitUpdated(ProfileSnapshot profile) {
    emit(EditProfileSuccess(profile: profile));
  }

  String? _requireText(String? value) {
    if ((value?.trim() ?? '').isEmpty) {
      return translate('booking_validation_required');
    }
    return null;
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    return super.close();
  }
}
