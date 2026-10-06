import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileLocalDataSource _localDataSource;
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepoImpl(this._localDataSource, this._remoteDataSource);

  @override
  ProfileSnapshot? readProfile() => _localDataSource.readProfile();

  @override
  Future<Either<ServerFailure, ProfileSnapshot>> fetchAccount() async {
    try {
      final response = await _remoteDataSource.fetchAccount();
      final profile = _readAccount(response);
      if (profile == null) return Left(_unavailableFailure());
      await _localDataSource.saveProfile(profile);
      return Right(profile);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (_) {
      return Left(_unavailableFailure());
    }
  }

  ProfileSnapshot? _readAccount(Map<String, dynamic> response) {
    final user = response['user'];
    if (user is! Map) return null;
    final profile = ProfileSnapshot.fromJson(Map<String, dynamic>.from(user));
    if (profile.name.isEmpty &&
        profile.phone.isEmpty &&
        profile.email.isEmpty) {
      return null;
    }
    return profile;
  }

  ServerFailure _unavailableFailure() {
    return const ServerFailure(
      message: 'profile_unavailable',
      status: ApiFailureStatus.unsuccessful,
    );
  }
}
