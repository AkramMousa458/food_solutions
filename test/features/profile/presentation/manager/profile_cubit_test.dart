import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_state.dart';

void main() {
  test('loads the cached profile', () {
    final inputProfile = _profile();
    final mockRepository = _MockProfileRepo(profile: inputProfile);
    final cubit = ProfileCubit(mockRepository);
    addTearDown(cubit.close);
    cubit.loadProfile();
    final actualState = cubit.state;
    final expectedState = ProfileSuccess(profile: inputProfile);
    expect(actualState, expectedState);
  });

  test('selects another establishment', () {
    final inputProfile = _profile(
      establishments: const [
        ProfileEstablishmentSnapshot(name: 'Nirvana Cafe', isActive: true),
        ProfileEstablishmentSnapshot(name: 'Olaya Branch', isActive: true),
      ],
    );
    final mockRepository = _MockProfileRepo(profile: inputProfile);
    final cubit = ProfileCubit(mockRepository);
    addTearDown(cubit.close);
    cubit.loadProfile();
    cubit.selectEstablishment(1);
    final actualState = cubit.state as ProfileSuccess;
    expect(actualState.selectedEstablishmentIndex, 1);
    expect(actualState.selectedEstablishment?.name, 'Olaya Branch');
  });

  test('fails when no profile is saved', () {
    final mockRepository = _MockProfileRepo(profile: null);
    final cubit = ProfileCubit(mockRepository);
    addTearDown(cubit.close);
    cubit.loadProfile();
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

  _MockProfileRepo({required this.profile});

  @override
  ProfileSnapshot? readProfile() => profile;
}
