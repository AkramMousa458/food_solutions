import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/delete_establishment_response.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/models/update_profile_request.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileLocalDataSource _localDataSource;
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepoImpl(this._localDataSource, this._remoteDataSource);

  @override
  ProfileSnapshot? readProfile() => _localDataSource.readProfile();

  @override
  Future<Either<ServerFailure, ProfileSnapshot>> fetchAccount() {
    return _loadAccount(_remoteDataSource.fetchAccount());
  }

  @override
  Future<Either<ServerFailure, ProfileSnapshot>> updateAccount(
    UpdateProfileRequest request,
  ) {
    return _loadAccount(_remoteDataSource.updateAccount(request));
  }

  Future<Either<ServerFailure, ProfileSnapshot>> _loadAccount(
    Future<Map<String, dynamic>> request,
  ) async {
    try {
      final response = await request;
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

  @override
  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  createEstablishment(CreateEstablishmentRequest request) {
    return _storeEstablishment(_remoteDataSource.createEstablishment(request));
  }

  @override
  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  updateEstablishment(int id, CreateEstablishmentRequest request) {
    return _storeEstablishment(
      _remoteDataSource.updateEstablishment(id, request),
    );
  }

  @override
  Future<Either<ServerFailure, DeleteEstablishmentResponse>>
  deleteEstablishment(int id) async {
    try {
      final response = await _remoteDataSource.deleteEstablishment(id);
      final deleted = DeleteEstablishmentResponse.fromJson(response);
      if (!deleted.isSuccess) {
        final message = deleted.message.trim();
        return Left(
          ServerFailure(
            message: message.isEmpty
                ? ApiErrorMessages.unexpectedError
                : message,
            status: ApiFailureStatus.unsuccessful,
            data: response,
          ),
        );
      }
      await _removeEstablishment(id);
      return Right(deleted);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (_) {
      return Left(_unexpectedFailure());
    }
  }

  Future<Either<ServerFailure, CreateEstablishmentResponse>>
  _storeEstablishment(Future<Map<String, dynamic>> request) async {
    try {
      final response = await request;
      final mapped = _mapCreatedEstablishment(response);
      final stored = mapped.fold<CreateEstablishmentResponse?>(
        (_) => null,
        (value) => value,
      );
      final establishment = stored?.establishment;
      if (establishment != null) {
        await _saveCreatedEstablishment(establishment);
      }
      return mapped;
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (_) {
      return Left(_unexpectedFailure());
    }
  }

  Either<ServerFailure, CreateEstablishmentResponse> _mapCreatedEstablishment(
    Map<String, dynamic> response,
  ) {
    final created = CreateEstablishmentResponse.fromJson(response);
    final establishment = created.establishment;
    if (!created.isSuccess || establishment == null) {
      final message = created.message.trim();
      return Left(
        ServerFailure(
          message: message.isEmpty ? ApiErrorMessages.unexpectedError : message,
          status: ApiFailureStatus.unsuccessful,
          data: response,
        ),
      );
    }
    return Right(created);
  }

  Future<void> _saveCreatedEstablishment(
    ProfileEstablishmentSnapshot establishment,
  ) async {
    final profile = _localDataSource.readProfile();
    if (profile == null) return;
    await _localDataSource.saveProfile(
      profile.copyWith(
        establishments: _mergeEstablishment(
          profile.establishments,
          establishment,
        ),
      ),
    );
  }

  Future<void> _removeEstablishment(int id) async {
    final profile = _localDataSource.readProfile();
    if (profile == null) return;
    await _localDataSource.saveProfile(
      profile.copyWith(
        establishments: profile.establishments
            .where((item) => item.id != id)
            .toList(),
      ),
    );
  }

  List<ProfileEstablishmentSnapshot> _mergeEstablishment(
    List<ProfileEstablishmentSnapshot> current,
    ProfileEstablishmentSnapshot created,
  ) {
    final index = current.indexWhere((item) {
      return item.id != null && item.id == created.id;
    });
    if (index < 0) return [...current, created];
    final next = List<ProfileEstablishmentSnapshot>.of(current);
    next[index] = created;
    return next;
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
    final establishments = _readAccountEstablishments(
      response['establishments'],
    );
    if (establishments.isEmpty) return profile;
    return profile.copyWith(establishments: establishments);
  }

  List<ProfileEstablishmentSnapshot> _readAccountEstablishments(Object? value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((item) {
          return ProfileEstablishmentSnapshot.fromJson(
            Map<String, dynamic>.from(item),
          );
        })
        .where((item) => item.name.isNotEmpty)
        .toList();
  }

  ServerFailure _unavailableFailure() {
    return const ServerFailure(
      message: 'profile_unavailable',
      status: ApiFailureStatus.unsuccessful,
    );
  }

  ServerFailure _unexpectedFailure() {
    return ServerFailure(
      message: ApiErrorMessages.unexpectedError,
      status: ApiFailureStatus.unexpected,
    );
  }
}
