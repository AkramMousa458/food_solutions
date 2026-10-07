import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/delete_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/models/update_profile_request.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_state.dart';

void main() {
  test('creates an establishment from the form', () async {
    const inputEstablishment = ProfileEstablishmentSnapshot(
      id: 3,
      name: 'مقهى بوخاريست',
      isActive: true,
      status: 'existing',
      userPosition: 'owner',
    );
    final mockRepository = _MockProfileRepo(
      response: const CreateEstablishmentResponse(
        isSuccess: true,
        message: 'تم إنشاء حساب المنشأة بنجاح.',
        establishment: inputEstablishment,
      ),
    );
    final cubit = CreateEstablishmentCubit(mockRepository);
    addTearDown(cubit.close);
    cubit.nameController.text = 'مقهى بوخاريست';
    cubit.phoneController.text = '0501234567';
    cubit.ageController.text = 'سنتين';
    cubit.addressController.text = 'الرياض - طريق الملك فهد';
    cubit.imageController.text = 'https://example.com/logo.png';
    cubit.locationController.text =
        'https://maps.google.com/?q=24.7136,46.6753';
    cubit.selectStatus(CreateEstablishmentRequest.underConstructionStatus);
    cubit.selectPosition(CreateEstablishmentRequest.authorizedPosition);
    await cubit.createEstablishment();
    final actualState = cubit.state;
    expect(actualState, isA<CreateEstablishmentSuccess>());
    final success = actualState as CreateEstablishmentSuccess;
    expect(success.message, 'تم إنشاء حساب المنشأة بنجاح.');
    expect(success.establishment.id, 3);
    expect(
      mockRepository.lastRequest?.status,
      CreateEstablishmentRequest.underConstructionStatus,
    );
    expect(
      mockRepository.lastRequest?.userPosition,
      CreateEstablishmentRequest.authorizedPosition,
    );
    expect(mockRepository.lastRequest?.name, 'مقهى بوخاريست');
    expect(mockRepository.lastRequest?.age, 'سنتين');
    expect(
      mockRepository.lastRequest?.location,
      'https://maps.google.com/?q=24.7136,46.6753',
    );
    expect(mockRepository.updatedId, isNull);
  });

  test('updates an establishment when the form is editing', () async {
    const inputEstablishment = ProfileEstablishmentSnapshot(
      id: 6,
      name: 'مقهى الأفق الجديد',
      phone: '0509998877',
      ageLabel: '3 سنوات',
      isActive: true,
      status: 'existing',
      userPosition: 'manager',
    );
    final mockRepository = _MockProfileRepo(
      response: const CreateEstablishmentResponse(
        isSuccess: true,
        message: 'تم تحديث بيانات المنشأة بنجاح.',
        establishment: inputEstablishment,
      ),
    );
    final cubit = CreateEstablishmentCubit(mockRepository);
    addTearDown(cubit.close);
    cubit.prefill(
      const ProfileEstablishmentSnapshot(
        id: 6,
        name: 'test',
        phone: '01097066403',
        isActive: true,
        status: 'existing',
        userPosition: 'owner',
      ),
    );
    cubit.nameController.text = 'مقهى الأفق الجديد';
    cubit.phoneController.text = '0509998877';
    cubit.ageController.text = '3 سنوات';
    cubit.selectPosition(CreateEstablishmentRequest.managerPosition);
    await cubit.createEstablishment();
    final actualState = cubit.state;
    expect(actualState, isA<CreateEstablishmentSuccess>());
    final success = actualState as CreateEstablishmentSuccess;
    expect(success.message, 'تم تحديث بيانات المنشأة بنجاح.');
    expect(success.establishment.name, 'مقهى الأفق الجديد');
    expect(mockRepository.updatedId, 6);
    expect(mockRepository.lastRequest?.userPosition, 'manager');
    expect(mockRepository.lastRequest?.age, '3 سنوات');
  });

  test('keeps the repository failure status', () async {
    final mockRepository = _MockProfileRepo(
      failure: const ServerFailure(
        message: 'Unauthenticated.',
        status: ApiFailureStatus.unauthorized,
        statusCode: 401,
      ),
    );
    final cubit = CreateEstablishmentCubit(mockRepository);
    addTearDown(cubit.close);
    cubit.nameController.text = 'مقهى بوخاريست';
    cubit.phoneController.text = '0501234567';
    cubit.ageController.text = 'سنتين';
    cubit.addressController.text = 'الرياض';
    await cubit.createEstablishment();
    final actualState = cubit.state;
    expect(
      actualState,
      const CreateEstablishmentFailure(
        message: 'Unauthenticated.',
        status: ApiFailureStatus.unauthorized,
        statusCode: 401,
      ),
    );
  });
}

class _MockProfileRepo implements ProfileRepo {
  final CreateEstablishmentResponse? response;
  final ServerFailure? failure;
  CreateEstablishmentRequest? lastRequest;
  int? updatedId;

  _MockProfileRepo({this.response, this.failure});

  @override
  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  createEstablishment(CreateEstablishmentRequest request) async {
    lastRequest = request;
    return _createdOrFailure();
  }

  @override
  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  updateEstablishment(int id, CreateEstablishmentRequest request) async {
    updatedId = id;
    lastRequest = request;
    return _createdOrFailure();
  }

  @override
  Future<Either<ServerFailure, DeleteEstablishmentResponse>>
  deleteEstablishment(int id) async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
  }

  Either<ServerFailure, CreateEstablishmentResponse> _createdOrFailure() {
    final error = failure;
    final created = response;
    if (error != null) return Left(error);
    if (created == null) {
      return const Left(
        ServerFailure(
          message: 'unexpected',
          status: ApiFailureStatus.unexpected,
        ),
      );
    }
    return Right(created);
  }

  @override
  Future<Either<ServerFailure, ProfileSnapshot>> updateAccount(
    UpdateProfileRequest request,
  ) async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, ProfileSnapshot>> fetchAccount() async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
  }

  @override
  ProfileSnapshot? readProfile() => null;
}
