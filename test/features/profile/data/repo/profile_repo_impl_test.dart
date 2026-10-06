import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo_impl.dart';

void main() {
  test('returns the stored profile', () {
    final inputProfile = _profile();
    final mockDataSource = _MockProfileLocalDataSource(profile: inputProfile);
    final repository = ProfileRepoImpl(
      mockDataSource,
      _MockProfileRemoteDataSource(),
    );
    final actualProfile = repository.readProfile();
    expect(actualProfile, inputProfile);
  });

  test('maps the account user and stores it', () async {
    final mockLocalDataSource = _MockProfileLocalDataSource(profile: null);
    final mockRemoteDataSource = _MockProfileRemoteDataSource(
      response: _accountResponse(),
    );
    final repository = ProfileRepoImpl(
      mockLocalDataSource,
      mockRemoteDataSource,
    );
    final actualResult = await repository.fetchAccount();
    expect(actualResult.isRight(), isTrue);
    final actualProfile = actualResult.getOrElse(
      () => throw StateError('expected account'),
    );
    expect(actualProfile.name, 'Akram Mousa');
    expect(actualProfile.role, 'admin');
    expect(actualProfile.email, 'akrammousa458@gmail.com');
    expect(actualProfile.isEmailVerified, isTrue);
    expect(actualProfile.isPhoneVerified, isFalse);
    expect(actualProfile.establishments.single.name, 'مقهى ومطعم الأفق');
    expect(
      actualProfile.establishments.single.headquarters,
      'الرياض - طريق الملك فهد',
    );
    expect(actualProfile.establishments.single.ageLabel, 'سنتين');
    expect(actualProfile.establishments.single.userPosition, 'owner');
    expect(actualProfile.establishments.single.isActive, isTrue);
    expect(mockLocalDataSource.savedProfile, actualProfile);
  });

  test('returns unavailable when the account user is missing', () async {
    final repository = ProfileRepoImpl(
      _MockProfileLocalDataSource(profile: null),
      _MockProfileRemoteDataSource(response: <String, dynamic>{}),
    );
    final actualResult = await repository.fetchAccount();
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.message, 'profile_unavailable');
    expect(actualFailure.status, ApiFailureStatus.unsuccessful);
  });

  test('maps dio errors from the account request', () async {
    final requestOptions = RequestOptions(path: 'api/account');
    final repository = ProfileRepoImpl(
      _MockProfileLocalDataSource(profile: null),
      _MockProfileRemoteDataSource(
        error: DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.badResponse,
          response: Response<Map<String, dynamic>>(
            requestOptions: requestOptions,
            statusCode: 401,
            data: <String, dynamic>{'message': 'Unauthenticated.'},
          ),
        ),
      ),
    );
    final actualResult = await repository.fetchAccount();
    expect(actualResult.isLeft(), isTrue);
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.status, ApiFailureStatus.unauthorized);
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

Map<String, dynamic> _accountResponse() {
  return <String, dynamic>{
    'user': <String, dynamic>{
      'id': 5,
      'name': 'Akram Mousa',
      'email': 'akrammousa458@gmail.com',
      'phone': '01097066403',
      'email_verified_at': '2026-10-04T23:22:44.000000Z',
      'phone_verified_at': null,
      'role': 'admin',
      'establishments': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 1,
          'name': 'مقهى ومطعم الأفق',
          'phone': '0501234567',
          'age': 'سنتين',
          'image': 'https://example.com/logo.png',
          'address': 'الرياض - طريق الملك فهد',
          'status': 'existing',
          'user_position': 'owner',
          'is_active': true,
        },
      ],
    },
  };
}

class _MockProfileLocalDataSource implements ProfileLocalDataSource {
  final ProfileSnapshot? profile;
  ProfileSnapshot? savedProfile;

  _MockProfileLocalDataSource({required this.profile});

  @override
  ProfileSnapshot? readProfile() => profile;

  @override
  Future<void> saveProfile(ProfileSnapshot profile) async {
    savedProfile = profile;
  }
}

class _MockProfileRemoteDataSource implements ProfileRemoteDataSource {
  final Map<String, dynamic>? response;
  final DioException? error;

  _MockProfileRemoteDataSource({this.response, this.error});

  @override
  Future<Map<String, dynamic>> fetchAccount() async {
    final dioError = error;
    if (dioError != null) throw dioError;
    return response ?? <String, dynamic>{};
  }
}
