import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:food_solutions/core/utils/app_string.dart';
import 'package:food_solutions/core/utils/local_storage.dart';
import 'package:food_solutions/core/services/api_service.dart';

import 'package:food_solutions/features/services/data/data_sources/services_remote_data_source.dart';
import 'package:food_solutions/features/services/data/repo/services_repo.dart';
import 'package:food_solutions/features/services/data/repo/services_repo_impl.dart';
import 'package:food_solutions/features/services/presentation/manager/services_cubit.dart';

import 'package:food_solutions/features/contact/data/data_sources/contact_remote_data_source.dart';
import 'package:food_solutions/features/contact/data/repo/contact_repo.dart';
import 'package:food_solutions/features/contact/data/repo/contact_repo_impl.dart';
import 'package:food_solutions/features/contact/presentation/manager/contact_cubit.dart';

import 'package:food_solutions/features/booking/data/data_sources/booking_remote_data_source.dart';
import 'package:food_solutions/features/booking/data/repo/booking_repo.dart';
import 'package:food_solutions/features/booking/data/repo/booking_repo_impl.dart';
import 'package:food_solutions/features/booking/presentation/manager/booking_cubit.dart';

import 'package:food_solutions/features/home/data/data_sources/statistics_remote_data_source.dart';
import 'package:food_solutions/features/home/data/repo/statistics_repo.dart';
import 'package:food_solutions/features/home/data/repo/statistics_repo_impl.dart';
import 'package:food_solutions/features/home/presentation/manager/statistics_cubit.dart';

import 'package:food_solutions/features/home/data/data_sources/home_sections_remote_data_source.dart';
import 'package:food_solutions/features/home/data/repo/home_sections_repo.dart';
import 'package:food_solutions/features/home/data/repo/home_sections_repo_impl.dart';
import 'package:food_solutions/features/home/presentation/manager/home_sections_cubit.dart';

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
  locator.registerLazySingleton<ServicesRepo>(
    () => ServicesRepoImpl(locator<ServicesRemoteDataSource>()),
  );
  locator.registerLazySingleton<ServicesCubit>(
    () => ServicesCubit(locator<ServicesRepo>()),
  );

  // Contact
  locator.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSourceImpl(locator<ApiService>()),
  );
  locator.registerLazySingleton<ContactRepo>(
    () => ContactRepoImpl(locator<ContactRemoteDataSource>()),
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
  locator.registerLazySingleton<StatisticsRepo>(
    () => StatisticsRepoImpl(locator<StatisticsRemoteDataSource>()),
  );
  locator.registerLazySingleton<StatisticsCubit>(
    () => StatisticsCubit(locator<StatisticsRepo>()),
  );

  // Home Sections
  locator.registerLazySingleton<HomeSectionsRemoteDataSource>(
    () => HomeSectionsRemoteDataSourceImpl(locator<ApiService>()),
  );
  locator.registerLazySingleton<HomeSectionsRepo>(
    () => HomeSectionsRepoImpl(locator<HomeSectionsRemoteDataSource>()),
  );
  locator.registerLazySingleton<HomeSectionsCubit>(
    () => HomeSectionsCubit(locator<HomeSectionsRepo>()),
  );
}
