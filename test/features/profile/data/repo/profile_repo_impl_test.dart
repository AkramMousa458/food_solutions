import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:food_solutions/features/profile/data/models/create_establishment_request.dart';
import 'package:food_solutions/features/profile/data/models/profile_snapshot.dart';
import 'package:food_solutions/features/profile/data/models/update_profile_request.dart';
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
    expect(actualProfile.establishments, hasLength(2));
    expect(actualProfile.establishments.first.name, 'test');
    expect(actualProfile.establishments.first.headquarters, isNull);
    expect(actualProfile.establishments.first.ageLabel, isNull);
    expect(actualProfile.establishments.first.imageUrl, isNull);
    expect(actualProfile.establishments.first.isActive, isTrue);
    final complete = actualProfile.establishments.last;
    expect(complete.name, 'مقهى ومطعم الأفق');
    expect(complete.headquarters, 'الرياض - طريق الملك فهد');
    expect(complete.ageLabel, 'سنتين');
    expect(complete.imageUrl, 'https://example.com/logo.png');
    expect(complete.latitude, '24.7136000');
    expect(complete.longitude, '46.6753000');
    expect(complete.userPosition, 'owner');
    expect(complete.isActive, isTrue);
    expect(mockLocalDataSource.savedProfile, actualProfile);
  });

  test('updates the account and keeps the returned establishments', () async {
    const inputRequest = UpdateProfileRequest(
      name: 'محمد أحمد المحدث',
      phone: '01097066403',
      email: 'mohamed_updated@example.com',
    );
    final mockLocalDataSource = _MockProfileLocalDataSource(profile: null);
    final mockRemoteDataSource = _MockProfileRemoteDataSource(
      updateAccountResponse: <String, dynamic>{
        'user': <String, dynamic>{
          'id': 5,
          'name': 'محمد أحمد المحدث',
          'email': 'mohamed_updated@example.com',
          'phone': '01097066403',
          'email_verified_at': '2026-10-04T23:22:44.000000Z',
          'phone_verified_at': null,
          'role': 'admin',
        },
        'establishments': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 3,
            'name': 'مقهى بوخاريست',
            'age': 'سنتين',
            'address': 'الرياض - طريق الملك فهد',
            'status': 'existing',
            'user_position': 'owner',
            'is_active': true,
          },
          <String, dynamic>{
            'id': 1,
            'name': 'مقهى ومطعم الأفق',
            'status': 'under_construction',
            'user_position': 'owner',
            'is_active': true,
          },
        ],
      },
    );
    final repository = ProfileRepoImpl(
      mockLocalDataSource,
      mockRemoteDataSource,
    );
    final actualResult = await repository.updateAccount(inputRequest);
    expect(mockRemoteDataSource.lastUpdateRequest?.toJson(), inputRequest.toJson());
    expect(actualResult.isRight(), isTrue);
    final actualProfile = actualResult.getOrElse(
      () => throw StateError('expected account'),
    );
    expect(actualProfile.name, 'محمد أحمد المحدث');
    expect(actualProfile.email, 'mohamed_updated@example.com');
    expect(actualProfile.isEmailVerified, isTrue);
    expect(actualProfile.isPhoneVerified, isFalse);
    expect(actualProfile.establishments, hasLength(2));
    expect(actualProfile.establishments.first.status, 'existing');
    expect(actualProfile.establishments.last.status, 'under_construction');
    expect(mockLocalDataSource.savedProfile, actualProfile);
  });

  test('updates an establishment and stores the new details', () async {
    const inputRequest = CreateEstablishmentRequest(
      name: 'مقهى الأفق الجديد',
      phone: '0509998877',
      age: '3 سنوات',
      image: '',
      location: '',
      address: '',
      status: 'existing',
      userPosition: 'manager',
    );
    final mockLocalDataSource = _MockProfileLocalDataSource(
      profile: _profile(
        establishments: const [
          ProfileEstablishmentSnapshot(id: 6, name: 'test', isActive: true),
        ],
      ),
    );
    final mockRemoteDataSource = _MockProfileRemoteDataSource(
      updateResponse: <String, dynamic>{
        'success': true,
        'message': 'تم تحديث بيانات المنشأة بنجاح.',
        'data': <String, dynamic>{
          'id': 6,
          'name': 'مقهى الأفق الجديد',
          'phone': '0509998877',
          'age': '3 سنوات',
          'image': null,
          'location': null,
          'address': null,
          'status': 'existing',
          'user_position': 'manager',
          'is_active': true,
        },
      },
    );
    final repository = ProfileRepoImpl(
      mockLocalDataSource,
      mockRemoteDataSource,
    );
    final actualResult = await repository.updateEstablishment(6, inputRequest);
    expect(mockRemoteDataSource.lastEstablishmentId, 6);
    expect(mockRemoteDataSource.lastRequest?.name, 'مقهى الأفق الجديد');
    expect(actualResult.isRight(), isTrue);
    final actualResponse = actualResult.getOrElse(
      () => throw StateError('expected establishment'),
    );
    expect(actualResponse.message, 'تم تحديث بيانات المنشأة بنجاح.');
    expect(actualResponse.establishment?.userPosition, 'manager');
    expect(actualResponse.establishment?.ageLabel, '3 سنوات');
    expect(
      mockLocalDataSource.savedProfile?.establishments.single.name,
      'مقهى الأفق الجديد',
    );
  });

  test('deletes an establishment and removes it from the profile', () async {
    final mockLocalDataSource = _MockProfileLocalDataSource(
      profile: _profile(
        establishments: const [
          ProfileEstablishmentSnapshot(id: 7, name: 'test', isActive: true),
          ProfileEstablishmentSnapshot(
            id: 6,
            name: 'مقهى الأفق الجديد',
            isActive: true,
          ),
        ],
      ),
    );
    final mockRemoteDataSource = _MockProfileRemoteDataSource(
      deleteResponse: <String, dynamic>{
        'success': true,
        'message': 'تم حذف المنشأة بنجاح.',
      },
    );
    final repository = ProfileRepoImpl(
      mockLocalDataSource,
      mockRemoteDataSource,
    );
    final actualResult = await repository.deleteEstablishment(7);
    expect(mockRemoteDataSource.lastEstablishmentId, 7);
    expect(actualResult.isRight(), isTrue);
    final actualResponse = actualResult.getOrElse(
      () => throw StateError('expected deletion'),
    );
    expect(actualResponse.message, 'تم حذف المنشأة بنجاح.');
    expect(mockLocalDataSource.savedProfile?.establishments.single.id, 6);
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

  test('creates an establishment and stores it on the profile', () async {
    const inputRequest = CreateEstablishmentRequest(
      name: 'مقهى بوخاريست',
      phone: '0501234567',
      age: 'سنتين',
      image: 'https://example.com/logo.png',
      location: 'https://maps.google.com/?q=24.7136,46.6753',
      address: 'الرياض - طريق الملك فهد',
      status: 'existing',
      userPosition: 'owner',
    );
    final mockLocalDataSource = _MockProfileLocalDataSource(
      profile: _profile(),
    );
    final mockRemoteDataSource = _MockProfileRemoteDataSource(
      createResponse: <String, dynamic>{
        'success': true,
        'message': 'تم إنشاء حساب المنشأة بنجاح.',
        'data': inputRequest.toJson()
          ..addAll(<String, dynamic>{
            'user_id': 5,
            'id': 3,
            'created_at': '2026-10-06T21:33:36.000000Z',
            'updated_at': '2026-10-06T21:33:36.000000Z',
          }),
      },
    );
    final repository = ProfileRepoImpl(
      mockLocalDataSource,
      mockRemoteDataSource,
    );
    final actualResult = await repository.createEstablishment(inputRequest);
    expect(mockRemoteDataSource.lastRequest?.toJson(), inputRequest.toJson());
    expect(actualResult.isRight(), isTrue);
    final actualResponse = actualResult.getOrElse(
      () => throw StateError('expected establishment'),
    );
    expect(actualResponse.message, 'تم إنشاء حساب المنشأة بنجاح.');
    expect(actualResponse.establishment?.id, 3);
    expect(actualResponse.establishment?.name, 'مقهى بوخاريست');
    expect(actualResponse.establishment?.ageLabel, 'سنتين');
    expect(actualResponse.establishment?.status, 'existing');
    expect(actualResponse.establishment?.isActive, isTrue);
    expect(actualResponse.establishment?.location, inputRequest.location);
    expect(
      mockLocalDataSource.savedProfile?.establishments.last.name,
      'مقهى بوخاريست',
    );
  });

  test('returns the api message when creation is unsuccessful', () async {
    const inputMessage = 'تعذر إنشاء المنشأة.';
    final repository = ProfileRepoImpl(
      _MockProfileLocalDataSource(profile: null),
      _MockProfileRemoteDataSource(
        createResponse: <String, dynamic>{
          'success': false,
          'message': inputMessage,
        },
      ),
    );
    final actualResult = await repository.createEstablishment(
      const CreateEstablishmentRequest(
        name: 'مقهى بوخاريست',
        phone: '0501234567',
        age: 'سنتين',
        image: '',
        location: '',
        address: 'الرياض',
        status: 'existing',
        userPosition: 'owner',
      ),
    );
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.message, inputMessage);
    expect(actualFailure.status, ApiFailureStatus.unsuccessful);
  });

  test('maps dio status codes from establishment creation', () async {
    final requestOptions = RequestOptions(path: 'api/establishments');
    final repository = ProfileRepoImpl(
      _MockProfileLocalDataSource(profile: null),
      _MockProfileRemoteDataSource(
        createError: DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.badResponse,
          response: Response<Map<String, dynamic>>(
            requestOptions: requestOptions,
            statusCode: 422,
            data: <String, dynamic>{
              'message': 'The given data was invalid.',
              'errors': <String, dynamic>{
                'name': <String>['The name field is required.'],
              },
            },
          ),
        ),
      ),
    );
    final actualResult = await repository.createEstablishment(
      const CreateEstablishmentRequest(
        name: '',
        phone: '',
        age: '',
        image: '',
        location: '',
        address: '',
        status: 'existing',
        userPosition: 'owner',
      ),
    );
    final actualFailure = actualResult.fold<ServerFailure>(
      (failure) => failure,
      (_) => throw StateError('expected failure'),
    );
    expect(actualFailure.status, ApiFailureStatus.validation);
    expect(actualFailure.statusCode, 422);
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

ProfileSnapshot _profile({
  List<ProfileEstablishmentSnapshot> establishments = const [],
}) {
  return ProfileSnapshot(
    name: 'Abdullah Al Saeed',
    role: 'owner',
    phone: '+966 50 123 4567',
    email: 'abdullah@foodsolutions.sa',
    initials: 'AS',
    establishments: establishments,
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
    },
    'establishments': <Map<String, dynamic>>[
      <String, dynamic>{
        'id': 7,
        'name': 'test',
        'phone': '01097066403',
        'age': null,
        'image': null,
        'location': null,
        'latitude': null,
        'longitude': null,
        'address': null,
        'status': 'existing',
        'user_position': 'owner',
        'is_active': true,
      },
      <String, dynamic>{
        'id': 1,
        'name': 'مقهى ومطعم الأفق',
        'phone': '0501234567',
        'age': 'سنتين',
        'image': 'https://example.com/logo.png',
        'location': 'https://maps.google.com/?q=24.7136,46.6753',
        'latitude': '24.7136000',
        'longitude': '46.6753000',
        'address': 'الرياض - طريق الملك فهد',
        'status': 'existing',
        'user_position': 'owner',
        'is_active': true,
      },
    ],
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
  final Map<String, dynamic>? createResponse;
  final Map<String, dynamic>? updateResponse;
  final Map<String, dynamic>? deleteResponse;
  final Map<String, dynamic>? updateAccountResponse;
  final DioException? error;
  final DioException? createError;
  CreateEstablishmentRequest? lastRequest;
  UpdateProfileRequest? lastUpdateRequest;
  int? lastEstablishmentId;

  _MockProfileRemoteDataSource({
    this.response,
    this.createResponse,
    this.updateResponse,
    this.deleteResponse,
    this.updateAccountResponse,
    this.error,
    this.createError,
  });

  @override
  Future<Map<String, dynamic>> fetchAccount() async {
    final dioError = error;
    if (dioError != null) throw dioError;
    return response ?? <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> updateAccount(UpdateProfileRequest request) async {
    lastUpdateRequest = request;
    final dioError = error;
    if (dioError != null) throw dioError;
    return updateAccountResponse ?? <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> createEstablishment(
    CreateEstablishmentRequest request,
  ) async {
    lastRequest = request;
    final dioError = createError;
    if (dioError != null) throw dioError;
    return createResponse ?? <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> updateEstablishment(
    int id,
    CreateEstablishmentRequest request,
  ) async {
    lastEstablishmentId = id;
    lastRequest = request;
    final dioError = createError;
    if (dioError != null) throw dioError;
    return updateResponse ?? <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> deleteEstablishment(int id) async {
    lastEstablishmentId = id;
    final dioError = createError;
    if (dioError != null) throw dioError;
    return deleteResponse ?? <String, dynamic>{};
  }
}
