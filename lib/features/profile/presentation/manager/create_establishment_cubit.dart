import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/presentation/establishment_phone.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_state.dart';

final RegExp _httpUrlPattern = RegExp(r'^https?:\/\/\S+$');

class CreateEstablishmentCubit extends Cubit<CreateEstablishmentState> {
  final ProfileRepo _profileRepo;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String status = CreateEstablishmentRequest.existingStatus;
  String userPosition = CreateEstablishmentRequest.ownerPosition;
  String? selectedAge;
  String legacyAge = '';
  ArabPhoneCode phoneCode = EstablishmentPhone.saudi;

  CreateEstablishmentCubit(this._profileRepo)
    : super(const CreateEstablishmentReady());

  void selectStatus(String value) {
    if (state is CreateEstablishmentLoading) return;
    if (!CreateEstablishmentRequest.statuses.contains(value)) return;
    status = value;
    emit(_ready());
  }

  void selectPosition(String value) {
    if (state is CreateEstablishmentLoading) return;
    if (!CreateEstablishmentRequest.positions.contains(value)) return;
    userPosition = value;
    emit(_ready());
  }

  void selectAge(String value) {
    if (state is CreateEstablishmentLoading) return;
    if (!CreateEstablishmentRequest.ages.contains(value)) return;
    selectedAge = value;
    legacyAge = '';
    emit(_ready());
  }

  void selectPhoneCode(String dial) {
    if (state is CreateEstablishmentLoading) return;
    final next = EstablishmentPhone.byDial(dial);
    if (next.dial != dial || next.dial == phoneCode.dial) return;
    phoneCode = next;
    final local = EstablishmentPhone.local(phoneController.text, next);
    phoneController.value = TextEditingValue(
      text: local,
      selection: TextSelection.collapsed(offset: local.length),
    );
    emit(_ready());
  }

  String? validateName(String? value) => _requireText(value);

  String? validatePhone(String? value) {
    final digits = EstablishmentPhone.local(value, phoneCode);
    if (digits.isEmpty) return translate('booking_validation_required');
    if (!EstablishmentPhone.isValid(value, phoneCode)) {
      return translate('booking_validation_phone');
    }
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
        validateOptionalUrl(imageController.text) == null &&
        validateOptionalUrl(locationController.text) == null;
  }

  int? editingId;

  bool get isEditing => editingId != null;

  void prefill(ProfileEstablishmentSnapshot establishment) {
    final id = establishment.id;
    if (id == null || state is CreateEstablishmentLoading) return;
    editingId = id;
    nameController.text = establishment.name;
    phoneCode = EstablishmentPhone.match(establishment.phone);
    phoneController.text = EstablishmentPhone.local(
      establishment.phone,
      phoneCode,
    );
    selectedAge = _matchAge(establishment.ageLabel);
    legacyAge = selectedAge == null
        ? (establishment.ageLabel?.trim() ?? '')
        : '';
    imageController.text = establishment.imageUrl ?? '';
    locationController.text = establishment.location ?? '';
    addressController.text = establishment.headquarters ?? '';
    status = _knownValue(
      establishment.status,
      CreateEstablishmentRequest.statuses,
      CreateEstablishmentRequest.existingStatus,
    );
    userPosition = _knownValue(
      establishment.userPosition,
      CreateEstablishmentRequest.positions,
      CreateEstablishmentRequest.ownerPosition,
    );
    emit(_ready());
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
    final id = editingId;
    final request = _request();
    final result = id == null
        ? await _profileRepo.createEstablishment(request)
        : await _profileRepo.updateEstablishment(id, request);
    result.fold(_emitFailure, _emitCreated);
  }

  CreateEstablishmentRequest _request() {
    return CreateEstablishmentRequest(
      name: nameController.text.trim(),
      phone: EstablishmentPhone.international(phoneController.text, phoneCode),
      age: selectedAge ?? legacyAge,
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

  CreateEstablishmentReady _ready() {
    return CreateEstablishmentReady(
      status: status,
      userPosition: userPosition,
      age: selectedAge,
      phoneDial: phoneCode.dial,
    );
  }

  String? _matchAge(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) return null;
    if (CreateEstablishmentRequest.ages.contains(value)) return value;
    for (final entry in CreateEstablishmentRequest.ageLabelKeys.entries) {
      if (translate(entry.value) == value) return entry.key;
    }
    return null;
  }

  String _knownValue(String? value, List<String> options, String fallback) {
    final current = value?.trim() ?? '';
    if (options.contains(current)) return current;
    return fallback;
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
    imageController.dispose();
    locationController.dispose();
    addressController.dispose();
    return super.close();
  }
}
