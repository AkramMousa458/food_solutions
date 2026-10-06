import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
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
}

ProfileSnapshot _profile({List<ProfileEstablishmentSnapshot>? establishments}) {
  return ProfileSnapshot(
    name: 'Abdullah Al Saeed',
    role: 'owner',
    phone: '+966 50 123 4567',
    email: 'abdullah@foodsolutions.sa',
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

  _MockProfileRepo({required this.profile, this.failure});

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
  ProfileSnapshot? readProfile() => profile;
}
