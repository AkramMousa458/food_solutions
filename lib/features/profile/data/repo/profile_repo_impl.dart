import 'package:food_solutions/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileLocalDataSource _localDataSource;

  ProfileRepoImpl(this._localDataSource);

  @override
  ProfileSnapshot? readProfile() => _localDataSource.readProfile();
}
