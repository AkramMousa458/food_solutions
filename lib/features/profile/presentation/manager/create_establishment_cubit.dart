import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_response.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_state.dart';

final RegExp _httpUrlPattern = RegExp(r'^https?:\/\/\S+$');

class CreateEstablishmentCubit extends Cubit<CreateEstablishmentState> {
  final ProfileRepo _profileRepo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String status = CreateEstablishmentRequest.existingStatus;
  String userPosition = CreateEstablishmentRequest.ownerPosition;

  CreateEstablishmentCubit(this._profileRepo)
    : super(const CreateEstablishmentReady());

  void selectStatus(String value) {
    if (state is CreateEstablishmentLoading) return;
    if (!CreateEstablishmentRequest.statuses.contains(value)) return;
    status = value;
    emit(CreateEstablishmentReady(status: status, userPosition: userPosition));
  }

  void selectPosition(String value) {
    if (state is CreateEstablishmentLoading) return;
    if (!CreateEstablishmentRequest.positions.contains(value)) return;
    userPosition = value;
    emit(CreateEstablishmentReady(status: status, userPosition: userPosition));
  }

  String? validateName(String? value) => _requireText(value);

  String? validatePhone(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return translate('booking_validation_required');
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) return translate('booking_validation_phone');
    return null;
  }

  // String? validateAddress(String? value) => _requireText(value);

  String? validateOptionalUrl(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return null;
    if (!_httpUrlPattern.hasMatch(input)) {
      return translate('establishment_validation_url');
    }
    return null;
  }

  bool get canSubmit {
    return validateName(nameController.text) == null &&
        validatePhone(phoneController.text) == null &&
        validateOptionalUrl(imageController.text) == null;
  }

  Future<void> createEstablishment() async {
    if (state is CreateEstablishmentLoading) return;
    if (!canSubmit) {
      emit(
        CreateEstablishmentFailure(
          message: translate('validationError'),
          status: ApiFailureStatus.validation,
        ),
      );
      return;
    }
    emit(const CreateEstablishmentLoading());
    final result = await _profileRepo.createEstablishment(_request());
    result.fold(_emitFailure, _emitCreated);
  }

  CreateEstablishmentRequest _request() {
    return CreateEstablishmentRequest(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      age: ageController.text.trim(),
      image: imageController.text.trim(),
      location: locationController.text.trim(),
      address: addressController.text.trim(),
      status: status,
      userPosition: userPosition,
    );
  }

  void _emitFailure(ServerFailure failure) {
    emit(
      CreateEstablishmentFailure(
        message: failure.message,
        status: failure.status,
        statusCode: failure.statusCode,
      ),
    );
  }

  void _emitCreated(CreateEstablishmentResponse response) {
    final establishment = response.establishment;
    if (establishment == null) {
      emit(
        CreateEstablishmentFailure(
          message: translate('unexpectedError'),
          status: ApiFailureStatus.unexpected,
        ),
      );
      return;
    }
    emit(
      CreateEstablishmentSuccess(
        message: response.message,
        establishment: establishment,
      ),
    );
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
    ageController.dispose();
    imageController.dispose();
    locationController.dispose();
    addressController.dispose();
    return super.close();
  }
}
