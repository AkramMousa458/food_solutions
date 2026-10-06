import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:food_solutions/core/utils/app_string.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/core/services/api_service.dart';

import 'package:food_solutions/features/services/data/data_sources/services_local_data_source.dart';
import 'package:food_solutions/features/services/data/data_sources/services_remote_data_source.dart';
import 'package:food_solutions/features/services/data/repo/services_repo.dart';
import 'package:food_solutions/features/services/data/repo/services_repo_impl.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';

import 'package:food_solutions/features/contact/data/data_sources/contact_local_data_source.dart';
import 'package:food_solutions/features/contact/data/data_sources/contact_remote_data_source.dart';
import 'package:food_solutions/features/contact/data/repo/contact_repo.dart';
import 'package:food_solutions/features/contact/data/repo/contact_repo_impl.dart';
import 'package:food_solutions/features/contact/presentation/manager/contact_cubit.dart';

import 'package:food_solutions/features/booking/data/data_sources/booking_remote_data_source.dart';
import 'package:food_solutions/features/booking/data/repo/booking_repo.dart';
import 'package:food_solutions/features/booking/data/repo/booking_repo_impl.dart';
import 'package:food_solutions/features/booking/presentation/manager/booking_cubit.dart';

import 'package:food_solutions/features/home/data/data_sources/statistics_local_data_source.dart';
import 'package:food_solutions/features/home/data/data_sources/statistics_remote_data_source.dart';
import 'package:food_solutions/features/home/data/repo/statistics_repo.dart';
import 'package:food_solutions/features/home/data/repo/statistics_repo_impl.dart';
import 'package:food_solutions/features/home/presentation/manager/statistics_cubit.dart';

import 'package:food_solutions/features/home/data/data_sources/home_sections_local_data_source.dart';
import 'package:food_solutions/features/home/data/data_sources/home_sections_remote_data_source.dart';
import 'package:food_solutions/features/home/data/repo/home_sections_repo.dart';
import 'package:food_solutions/features/home/data/repo/home_sections_repo_impl.dart';
import 'package:food_solutions/features/home/presentation/manager/home_sections_cubit.dart';

import 'package:food_solutions/features/favorites/data/data_sources/favorites_local_data_source.dart';
import 'package:food_solutions/features/favorites/data/repo/favorites_repo.dart';
import 'package:food_solutions/features/favorites/data/repo/favorites_repo_impl.dart';
import 'package:food_solutions/features/favorites/presentation/manager/favorites_cubit.dart';

import 'package:food_solutions/features/reviews/data/data_sources/reviews_remote_data_source.dart';
import 'package:food_solutions/features/reviews/data/repo/reviews_repo.dart';
import 'package:food_solutions/features/reviews/data/repo/reviews_repo_impl.dart';
import 'package:food_solutions/features/reviews/presentation/manager/reviews_cubit.dart';

import 'package:food_solutions/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:food_solutions/features/auth/data/data_sources/auth_session_data_source.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo.dart';
import 'package:food_solutions/features/auth/data/repo/auth_repo_impl.dart';
import 'package:food_solutions/features/auth/presentation/manager/login_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/otp_cubit.dart';
import 'package:food_solutions/features/auth/presentation/manager/register_cubit.dart';
import 'package:food_solutions/features/splash/presentation/manager/splash_cubit.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_local_data_source.dart';
import 'package:food_solutions/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo.dart';
import 'package:food_solutions/features/profile/data/repo/profile_repo_impl.dart';
import 'package:food_solutions/features/profile/presentation/manager/create_establishment_cubit.dart';
import 'package:food_solutions/features/profile/presentation/manager/profile_cubit.dart';
import 'package:food_solutions/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:food_solutions/features/settings/data/repo/settings_repo.dart';
import 'package:food_solutions/features/settings/data/repo/settings_repo_impl.dart';
import 'package:food_solutions/features/settings/presentation/manager/settings_cubit.dart';

final locator = GetIt.instance;

Future<void> setupLocator({Logger? logger}) async {
  // Register logger first
  locator.registerSingleton<Logger>(
    logger ??
        Logger(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 80,
            colors: true,
            printEmojis: true,
          ),
        ),
  );

  // Register Dio with interceptors
  final dio = Dio()
    ..interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
        logPrint: (object) => locator<Logger>().d(object),
      ),
    );

  locator.registerSingleton<Dio>(dio);

  // Register ApiService
  locator.registerSingleton<ApiService>(
    ApiService(
      locator<Dio>(),
      logger: locator<Logger>(),
      baseUrl: AppString.baseUrl,
    ),
  );

  // Register LocalStorage
  locator.registerSingleton<LocalStorage>(
    await LocalStorage.init(logger: locator<Logger>()),
  );

  // Services
  locator.registerLazySingleton<ServicesRemoteDataSource>(
    () => ServicesRemoteDataSourceImpl(locator<ApiService>()),
  );
  locator.registerLazySingleton<ServicesLocalDataSource>(
    () => ServicesLocalDataSourceImpl(locator<LocalStorage>()),
  );
  locator.registerLazySingleton<ServicesRepo>(
    () => ServicesRepoImpl(
      remoteDataSource: locator<ServicesRemoteDataSource>(),
      localDataSource: locator<ServicesLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton<ServicesCubit>(
    () => ServicesCubit(locator<ServicesRepo>()),
  );

  // Contact
  locator.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSourceImpl(locator<ApiService>()),
  );
  locator.registerLazySingleton<ContactLocalDataSource>(
    () => ContactLocalDataSourceImpl(locator<LocalStorage>()),
  );
  locator.registerLazySingleton<ContactRepo>(
    () => ContactRepoImpl(
      remoteDataSource: locator<ContactRemoteDataSource>(),
      localDataSource: locator<ContactLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton<ContactCubit>(
    () => ContactCubit(locator<ContactRepo>()),
  );

  // Booking
  locator.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(locator<ApiService>()),
  );
  locator.registerLazySingleton<BookingRepo>(
    () => BookingRepoImpl(locator<BookingRemoteDataSource>()),
  );
  locator.registerLazySingleton<BookingCubit>(
    () => BookingCubit(locator<BookingRepo>()),
  );

  // Statistics
  locator.registerLazySingleton<StatisticsRemoteDataSource>(
    () => StatisticsRemoteDataSourceImpl(locator<ApiService>()),
  );
  locator.registerLazySingleton<StatisticsLocalDataSource>(
    () => StatisticsLocalDataSourceImpl(locator<LocalStorage>()),
  );
  locator.registerLazySingleton<StatisticsRepo>(
    () => StatisticsRepoImpl(
      remoteDataSource: locator<StatisticsRemoteDataSource>(),
      localDataSource: locator<StatisticsLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton<StatisticsCubit>(
    () => StatisticsCubit(locator<StatisticsRepo>()),
  );

  // Home Sections
  locator.registerLazySingleton<HomeSectionsRemoteDataSource>(
    () => HomeSectionsRemoteDataSourceImpl(locator<ApiService>()),
  );
  locator.registerLazySingleton<HomeSectionsLocalDataSource>(
    () => HomeSectionsLocalDataSourceImpl(locator<LocalStorage>()),
  );
  locator.registerLazySingleton<HomeSectionsRepo>(
    () => HomeSectionsRepoImpl(
      remoteDataSource: locator<HomeSectionsRemoteDataSource>(),
      localDataSource: locator<HomeSectionsLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton<HomeSectionsCubit>(
    () => HomeSectionsCubit(locator<HomeSectionsRepo>()),
  );

  // Favorites
  locator.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(locator<LocalStorage>()),
  );
  locator.registerLazySingleton<FavoritesRepo>(
    () => FavoritesRepoImpl(locator<FavoritesLocalDataSource>()),
  );
  locator.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(locator<FavoritesRepo>()),
  );

  // Reviews
  locator.registerLazySingleton<ReviewsRemoteDataSource>(
    () => ReviewsRemoteDataSourceImpl(locator<ApiService>()),
  );
  locator.registerLazySingleton<ReviewsRepo>(
    () => ReviewsRepoImpl(locator<ReviewsRemoteDataSource>()),
  );
  locator.registerLazySingleton<ReviewsCubit>(
    () => ReviewsCubit(locator<ReviewsRepo>()),
  );

  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator<ApiService>()),
  );
  locator.registerLazySingleton<AuthSessionDataSource>(
    () => AuthSessionDataSourceImpl(
      locator<LocalStorage>(),
      locator<ApiService>(),
    ),
  );
  locator.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      locator<AuthRemoteDataSource>(),
      sessionDataSource: locator<AuthSessionDataSource>(),
    ),
  );
  locator.registerFactory<LoginCubit>(() => LoginCubit(locator<AuthRepo>()));
  locator.registerFactory<RegisterCubit>(
    () => RegisterCubit(locator<AuthRepo>()),
  );
  locator.registerFactory<OtpCubit>(() => OtpCubit(locator<AuthRepo>()));
  locator.registerFactory<SplashCubit>(() => SplashCubit(locator<AuthRepo>()));
  locator.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(locator<LocalStorage>()),
  );
  locator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(locator<ApiService>()),
  );
  locator.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(
      locator<ProfileLocalDataSource>(),
      locator<ProfileRemoteDataSource>(),
    ),
  );
  locator.registerFactory<ProfileCubit>(
    () => ProfileCubit(locator<ProfileRepo>()),
  );
  locator.registerFactory<CreateEstablishmentCubit>(
    () => CreateEstablishmentCubit(locator<ProfileRepo>()),
  );
  locator.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(locator<LocalStorage>()),
  );
  locator.registerLazySingleton<SettingsRepo>(
    () => SettingsRepoImpl(
      locator<SettingsLocalDataSource>(),
      locator<AuthSessionDataSource>(),
    ),
  );
  locator.registerFactory<SettingsCubit>(
    () => SettingsCubit(locator<SettingsRepo>(), locator<ProfileRepo>()),
  );
}
