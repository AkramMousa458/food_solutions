import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/delete_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/models/update_profile_request.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/presentation/manager/edit_profile_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/edit_profile_state.dart';

void main() {
  test('updates the account from the form', () async {
    const inputProfile = ProfileSnapshot(
      name: 'محمد أحمد المحدث',
      role: 'admin',
      phone: '01097066403',
      email: 'mohamed_updated@example.com',
      initials: 'مم',
      emailVerifiedAt: '2026-10-04T23:22:44.000000Z',
      establishments: [
        ProfileEstablishmentSnapshot(
          id: 1,
          name: 'مقهى ومطعم الأفق',
          isActive: true,
          status: 'under_construction',
        ),
      ],
    );
    final mockRepository = _MockProfileRepo(profile: inputProfile);
    final cubit = EditProfileCubit(mockRepository);
    addTearDown(cubit.close);
    cubit.prefill(
      const ProfileSnapshot(
        name: 'Akram Mousa',
        role: 'admin',
        phone: '01097066403',
        email: 'akrammousa458@gmail.com',
        initials: 'AM',
      ),
    );
    cubit.nameController.text = 'محمد أحمد المحدث';
    cubit.emailController.text = 'mohamed_updated@example.com';
    await cubit.updateProfile();
    final actualState = cubit.state;
    expect(actualState, isA<EditProfileSuccess>());
    final success = actualState as EditProfileSuccess;
    expect(success.profile.name, 'محمد أحمد المحدث');
    expect(success.profile.establishments.single.status, 'under_construction');
    expect(mockRepository.lastRequest?.name, 'محمد أحمد المحدث');
    expect(mockRepository.lastRequest?.phone, '01097066403');
    expect(mockRepository.lastRequest?.email, 'mohamed_updated@example.com');
  });

  test('rejects an invalid email before calling the repository', () async {
    final mockRepository = _MockProfileRepo(profile: null);
    final cubit = EditProfileCubit(mockRepository);
    addTearDown(cubit.close);
    cubit.nameController.text = 'محمد أحمد';
    cubit.phoneController.text = '01097066403';
    cubit.emailController.text = 'not-an-email';
    expect(cubit.validateEmail(cubit.emailController.text), isNotNull);
    expect(cubit.canSubmit, isFalse);
  });
}

class _MockProfileRepo implements ProfileRepo {
  final ProfileSnapshot? profile;
  UpdateProfileRequest? lastRequest;

  _MockProfileRepo({required this.profile});

  @override
  Future<Either<ServerFailure, ProfileSnapshot>> updateAccount(
    UpdateProfileRequest request,
  ) async {
    lastRequest = request;
    final account = profile;
    if (account == null) {
      return const Left(
        ServerFailure(
          message: 'profile_unavailable',
          status: ApiFailureStatus.unsuccessful,
        ),
      );
    }
    return Right(account);
  }

  @override
  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  createEstablishment(CreateEstablishmentRequest request) async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
  }

  @override
  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  updateEstablishment(int id, CreateEstablishmentRequest request) async {
    return const Left(
      ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
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
  ProfileSnapshot? readProfile() => profile;
}
