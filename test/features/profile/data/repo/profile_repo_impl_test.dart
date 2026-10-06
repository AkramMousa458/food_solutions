import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo_impl.dart';

void main() {
  test('returns the stored profile', () {
    final inputProfile = _profile();
    final mockDataSource = _MockProfileLocalDataSource(profile: inputProfile);
    final repository = ProfileRepoImpl(mockDataSource);
    final actualProfile = repository.readProfile();
    expect(actualProfile, inputProfile);
  });
}

ProfileSnapshot _profile() {
  return const ProfileSnapshot(
    name: 'Abdullah Al Saeed',
    role: 'owner',
    phone: '+966 50 123 4567',
    email: 'abdullah@foodsolutions.sa',
    initials: 'AS',
  );
}

class _MockProfileLocalDataSource implements ProfileLocalDataSource {
  final ProfileSnapshot? profile;

  _MockProfileLocalDataSource({required this.profile});

  @override
  ProfileSnapshot? readProfile() => profile;
}
