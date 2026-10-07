import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/delete_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/models/update_profile_request.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_state.dart';

void main() {
  test('loads the account profile', () async {
    final inputProfile = _profile();
    final mockRepository = _MockProfileRepo(profile: inputProfile);
    final cubit = ProfileCubit(mockRepository);
    addTearDown(cubit.close);
    await cubit.loadProfile();
    final actualState = cubit.state;
    final expectedState = ProfileSuccess(profile: inputProfile);
    expect(actualState, expectedState);
  });

  test('selects another establishment', () async {
    final inputProfile = _profile(
      establishments: const [
        ProfileEstablishmentSnapshot(name: 'Nirvana Cafe', isActive: true),
        ProfileEstablishmentSnapshot(name: 'Olaya Branch', isActive: true),
      ],
    );
    final mockRepository = _MockProfileRepo(profile: inputProfile);
    final cubit = ProfileCubit(mockRepository);
    addTearDown(cubit.close);
    await cubit.loadProfile();
    cubit.selectEstablishment(1);
    final actualState = cubit.state as ProfileSuccess;
    expect(actualState.selectedEstablishmentIndex, 1);
    expect(actualState.selectedEstablishment?.name, 'Olaya Branch');
  });

  test('uses the cached profile when the account request fails', () async {
    final inputProfile = _profile();
    final mockRepository = _MockProfileRepo(
      profile: inputProfile,
      failure: const ServerFailure(
        message: 'unauthorized',
        status: ApiFailureStatus.unauthorized,
      ),
    );
    final cubit = ProfileCubit(mockRepository);
    addTearDown(cubit.close);
    await cubit.loadProfile();
    expect(cubit.state, ProfileSuccess(profile: inputProfile));
  });

  test('fails when the account request fails and nothing is cached', () async {
    final mockRepository = _MockProfileRepo(
      profile: null,
      failure: const ServerFailure(
        message: 'profile_unavailable',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
    final cubit = ProfileCubit(mockRepository);
    addTearDown(cubit.close);
    await cubit.loadProfile();
    expect(cubit.state, const ProfileFailure(message: 'profile_unavailable'));
  });

  test('deletes an establishment and keeps the remaining one selected', () async {
    final inputProfile = _profile(
      establishments: const [
        ProfileEstablishmentSnapshot(id: 7, name: 'test', isActive: true),
        ProfileEstablishmentSnapshot(
          id: 6,
          name: 'مقهى الأفق الجديد',
          isActive: true,
        ),
      ],
    );
    final mockRepository = _MockProfileRepo(profile: inputProfile);
    final cubit = ProfileCubit(mockRepository);
    addTearDown(cubit.close);
    await cubit.loadProfile();
    await cubit.deleteEstablishment(7);
    final actualState = cubit.state as ProfileSuccess;
    expect(mockRepository.deletedId, 7);
    expect(actualState.profile.establishments.single.id, 6);
    expect(actualState.selectedEstablishment?.name, 'مقهى الأفق الجديد');
    expect(actualState.feedback?.isError, isFalse);
    expect(actualState.feedback?.message, 'تم حذف المنشأة بنجاح.');
    expect(actualState.isBusy, isFalse);
  });

  test('keeps the profile when deleting an establishment fails', () async {
    final inputProfile = _profile(
      establishments: const [
        ProfileEstablishmentSnapshot(id: 7, name: 'test', isActive: true),
      ],
    );
    final mockRepository = _MockProfileRepo(
      profile: inputProfile,
      deleteFailure: const ServerFailure(
        message: 'تعذر حذف المنشأة.',
        status: ApiFailureStatus.unsuccessful,
      ),
    );
    final cubit = ProfileCubit(mockRepository);
    addTearDown(cubit.close);
    await cubit.loadProfile();
    await cubit.deleteEstablishment(7);
    final actualState = cubit.state as ProfileSuccess;
    expect(actualState.profile.establishments.single.id, 7);
    expect(actualState.feedback?.isError, isTrue);
    expect(actualState.feedback?.message, 'تعذر حذف المنشأة.');
    expect(actualState.isBusy, isFalse);
  });

  test('applies the saved profile after an account update', () async {
    final inputProfile = _profile(
      establishments: const [
        ProfileEstablishmentSnapshot(id: 3, name: 'مقهى بوخاريست', isActive: true),
        ProfileEstablishmentSnapshot(
          id: 1,
          name: 'مقهى ومطعم الأفق',
          isActive: true,
        ),
      ],
    );
    final updatedProfile = _profile(
      name: 'محمد أحمد المحدث',
      email: 'mohamed_updated@example.com',
      establishments: const [
        ProfileEstablishmentSnapshot(id: 3, name: 'مقهى بوخاريست', isActive: true),
        ProfileEstablishmentSnapshot(
          id: 1,
          name: 'مقهى ومطعم الأفق',
          isActive: true,
          status: 'under_construction',
        ),
      ],
    );
    final mockRepository = _MockProfileRepo(profile: inputProfile);
    final cubit = ProfileCubit(mockRepository);
    addTearDown(cubit.close);
    await cubit.loadProfile();
    cubit.selectEstablishment(1);
    mockRepository.savedProfile = updatedProfile;
    cubit.applyCachedProfile();
    final actualState = cubit.state as ProfileSuccess;
    expect(actualState.profile.name, 'محمد أحمد المحدث');
    expect(actualState.profile.email, 'mohamed_updated@example.com');
    expect(actualState.selectedEstablishmentIndex, 1);
    expect(actualState.selectedEstablishment?.status, 'under_construction');
  });
}

ProfileSnapshot _profile({
  String name = 'Abdullah Al Saeed',
  String email = 'abdullah@foodsolutions.sa',
  List<ProfileEstablishmentSnapshot>? establishments,
}) {
  return ProfileSnapshot(
    name: name,
    role: 'owner',
    phone: '+966 50 123 4567',
    email: email,
    initials: 'AS',
    phoneVerifiedAt: '2024-01-01T00:00:00Z',
    establishments:
        establishments ??
        const [
          ProfileEstablishmentSnapshot(
            name: 'Nirvana Cafe',
            headquarters: 'Riyadh',
            activity: 'Bakeries',
            ageInMonths: 24,
            isActive: true,
          ),
        ],
  );
}

class _MockProfileRepo implements ProfileRepo {
  final ProfileSnapshot? profile;
  final ServerFailure? failure;
  final ServerFailure? deleteFailure;
  int? deletedId;
  ProfileSnapshot? savedProfile;

  _MockProfileRepo({required this.profile, this.failure, this.deleteFailure});

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
    final error = deleteFailure;
    if (error != null) return Left(error);
    deletedId = id;
    return const Right(
      DeleteEstablishmentResponse(
        isSuccess: true,
        message: 'تم حذف المنشأة بنجاح.',
      ),
    );
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
    final error = failure;
    final account = profile;
    if (error != null) return Left(error);
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
  ProfileSnapshot? readProfile() {
    final saved = savedProfile;
    if (saved != null) return saved;
    final account = profile;
    final removedId = deletedId;
    if (account == null || removedId == null) return account;
    return account.copyWith(
      establishments: account.establishments
          .where((item) => item.id != removedId)
          .toList(),
    );
  }
}
