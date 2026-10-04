import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_solutions/core/error/failure.dart';
import 'package:food_solutions/core/language/app_translations.dart';
import 'package:food_solutions/features/auth/data/models/auth_user_model.dart';
import 'package:food_solutions/features/auth/data/models/login_request_model.dart';
import 'package:food_solutions/features/auth/data/models/login_response_model.dart';
import 'package:food_solutions/features/auth/data/models/register_request_model.dart';
import 'package:food_solutions/features/auth/data/models/register_response_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/send_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_request_model.dart';
import 'package:food_solutions/features/auth/data/models/verify_otp_response_model.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/presentation/manager/login_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/login_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockAuthRepo mockAuthRepo;
  late LoginCubit cubit;

  setUp(() {
    mockAuthRepo = _MockAuthRepo();
    cubit = LoginCubit(mockAuthRepo);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('rejects an empty login form', () async {
    await cubit.login();
    expect(mockAuthRepo.loginCallCount, 0);
    final actualState = cubit.state as LoginFailure;
    expect(actualState.status, ApiFailureStatus.validation);
    expect(actualState.message, translate('validationError'));
  });

  test('logs in with email and password', () async {
    const expectedUser = AuthUserModel(
      id: 4,
      name: 'محمد أحمد',
      email: 'mohmedetman955@gmail.com',
      phone: '0101255874141',
      role: 'client',
      establishments: [],
    );
    mockAuthRepo.loginResult = const Right(
      LoginResponseModel(token: '4|session-token', user: expectedUser),
    );
    cubit.identifierController.text = ' akrammousa458@gmail.com ';
    cubit.passwordController.text = '12345678';
    await cubit.login();
    expect(mockAuthRepo.loginCallCount, 1);
    expect(mockAuthRepo.lastRequest?.emailOrPhone, 'akrammousa458@gmail.com');
    expect(mockAuthRepo.lastRequest?.password, '12345678');
    expect(cubit.state, const LoginSuccess(user: expectedUser));
  });

  test('emits the invalid credentials message', () async {
    const inputMessage = 'بيانات الدخول غير صحيحة.';
    mockAuthRepo.loginResult = const Left(
      ServerFailure(
        message: inputMessage,
        status: ApiFailureStatus.validation,
        statusCode: 422,
      ),
    );
    cubit.identifierController.text = 'akrammousa458@gmail.com';
    cubit.passwordController.text = '12345678';
    await cubit.login();
    final actualState = cubit.state as LoginFailure;
    expect(actualState.message, inputMessage);
    expect(actualState.statusCode, 422);
  });
}

class _MockAuthRepo implements AuthRepo {
  int loginCallCount = 0;
  LoginRequestModel? lastRequest;
  Either<ServerFailure, LoginResponseModel> loginResult = const Left(
    ServerFailure(message: 'failed', status: ApiFailureStatus.unexpected),
  );

  @override
  Future<Either<ServerFailure, LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    loginCallCount += 1;
    lastRequest = request;
    return loginResult;
  }

  @override
  Future<Either<ServerFailure, SendOtpResponseModel>> sendOtp(
    SendOtpRequestModel request,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerFailure, VerifyOtpResponseModel>> verifyOtp(
    VerifyOtpRequestModel request,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<ServerFailure, RegisterResponseModel>> register(
    RegisterRequestModel request,
  ) async {
    throw UnimplementedError();
  }
}
