import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Core
import 'package:stylemate/core/network/network_info.dart';

// Auth Feature
import 'package:stylemate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:stylemate/features/auth/data/datasources/user_local_data_source.dart';
import 'package:stylemate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stylemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:stylemate/features/auth/domain/usecases/login_usecase.dart';
import 'package:stylemate/features/auth/domain/usecases/register_usecase.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_bloc.dart';

// Wardrobe Feature
import 'package:stylemate/features/wardrobe/data/datasources/wardrobe_remote_data_source.dart';
import 'package:stylemate/features/wardrobe/data/repositories/wardrobe_repository_impl.dart';
import 'package:stylemate/features/wardrobe/domain/repositories/wardrobe_repositorty.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/get_wardrobe_usecase.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/add_item_usecase.dart';
import 'package:stylemate/features/wardrobe/presentation/bloc/wardrobe_bloc.dart';

// Service Locator instance
final sl = GetIt.instance;

Future<void> init() async {
  // ===== Features - Auth =====

  // Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), registerUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // Repository
  // Repository (BENAR)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl()));
  sl.registerLazySingleton(() => UserLocalDataSource(sl()));

  // ===== Features - Wardrobe =====

  // Bloc
  sl.registerFactory(
    () => WardrobeBloc(getWardrobeUseCase: sl(), addItemUseCase: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetWardrobeUseCase(sl()));
  sl.registerLazySingleton(() => AddWardrobeItemUseCase(sl()));

  // Repository
  sl.registerLazySingleton<WardrobeRepository>(
    () => WardrobeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton(() => WardrobeRemoteDataSource(sl()));

  // ===== Core =====

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ===== External =====

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000', // Ganti dengan URL API kamu
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    ),
  );

  sl.registerLazySingleton(() => InternetConnectionChecker());
}
