import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylemate/core/network/dio_interceptor.dart';

// Core
import 'package:stylemate/core/network/network_info.dart';

// Auth Feature
import 'package:stylemate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:stylemate/features/auth/data/datasources/recommendation_remote_data_source.dart';
import 'package:stylemate/features/auth/data/datasources/user_local_data_source.dart';
import 'package:stylemate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stylemate/features/auth/data/repositories/recommendation_repository.dart';
import 'package:stylemate/features/auth/data/repositories/recommendation_repository_impl.dart';
import 'package:stylemate/features/auth/domain/repositories/auth_repository.dart';
import 'package:stylemate/features/auth/domain/usecases/get_recommendation_usecase.dart';
import 'package:stylemate/features/auth/domain/usecases/login_usecase.dart';
import 'package:stylemate/features/auth/domain/usecases/register_usecase.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_bloc.dart';
import 'package:stylemate/features/event/data/datasources/event_remote_data_source.dart';
import 'package:stylemate/features/event/domain/repositories/event_repository.dart';
import 'package:stylemate/features/event/domain/repositories/event_repository_impl.dart';
import 'package:stylemate/features/event/domain/usecases/create_event_usecase.dart';
import 'package:stylemate/features/event/domain/usecases/delete_event_usecase.dart';
import 'package:stylemate/features/event/domain/usecases/get_events_usecase.dart';
import 'package:stylemate/features/event/presentation/bloc/event_bloc.dart';


// Wardrobe Feature
import 'package:stylemate/features/wardrobe/data/datasources/wardrobe_remote_data_source.dart';
import 'package:stylemate/features/wardrobe/domain/repositories/wardrobe_repository_impl.dart';
import 'package:stylemate/features/wardrobe/domain/repositories/wardrobe_repositorty.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/delete_wardrobe_usecase.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/get_wardrobe_usecase.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/add_item_usecase.dart';
import 'package:stylemate/features/wardrobe/domain/usecases/update_wardrobe_usecase.dart';
import 'package:stylemate/features/wardrobe/presentation/bloc/wardrobe_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ================= EXTERNAL =================

  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => InternetConnectionChecker());

  // injection_container.dart

  // 1. Daftarkan Interceptor sebagai Singleton
  sl.registerLazySingleton(() => DioInterceptor());

  // 2. Modifikasi registrasi Dio
  sl.registerLazySingleton(
    () => Dio(
        BaseOptions(
          // Pastikan IP sesuai dengan laptop Anda yang menjalankan CI4
          baseUrl: 'http://10.42.189.26:8080/api',
          connectTimeout: const Duration(
            seconds: 30,
          ), // Naikkan agar tidak timeout
          receiveTimeout: const Duration(seconds: 30),
        ),
      )
      ..interceptors.add(
        sl<DioInterceptor>(),
      ), // <--- BARIS KRUSIAL: Tambahkan Interceptor di sini
  );

  // ================= CORE =================

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ================= AUTH FEATURE =================

  // Bloc
  //! Fitur - Event
  // Bloc
  sl.registerFactory(
    () => EventBloc(
      getEventsUseCase: sl(),
      createEventUseCase: sl(),
      deleteEventUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetEventsUseCase(sl()));
  sl.registerLazySingleton(() => CreateEventUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEventUseCase(sl()));

  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<EventRemoteDataSource>(
    // Menggunakan instance Dio yang sama dengan Wardrobe
    () => EventRemoteDataSource(sl()),
  );
  // ================= AUTH FEATURE =================

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      firebaseAuth: sl(),
      authRemoteDataSource:
          sl(), // <--- Ubah ini! Kita inject FirebaseAuth langsung
    ),
  );
  sl.registerFactory(() => RecommendationBloc(getRecommendationsUseCase: sl()));
  // Use cases
  sl.registerLazySingleton(() => GetRecommendationsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<RecommendationRepository>(
    () => RecommendationRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<RecommendationRemoteDataSource>(
    () => RecommendationRemoteDataSource(sl()), // sl() merujuk ke instance Dio
  );

  // UseCases (Boleh dibiarkan atau dihapus jika tidak dipakai)
  // sl.registerLazySingleton(() => LoginUseCase(sl())); ...
  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton(
    () => AuthRemoteDataSource(sl<Dio>(), sl<FirebaseAuth>()),
  );

  sl.registerLazySingleton(() => UserLocalDataSource(sl()));

  // ================= WARDROBE FEATURE =================

  // Bloc
  sl.registerFactory(
    () => WardrobeBloc(
      getWardrobeUseCase: sl(),
      addItemUseCase: sl(),
      updateItemUseCase: sl(), // ✅ Tambah ini
      deleteItemUseCase: sl(), // ✅ Tambah ini
    ),
  );
  // UseCases
  sl.registerLazySingleton(() => GetWardrobeUseCase(sl()));
  sl.registerLazySingleton(() => AddWardrobeItemUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWardrobeItemUseCase(sl())); // ✅ WAJIB
  sl.registerLazySingleton(() => DeleteWardrobeItemUseCase(sl()));

  // Repository
  sl.registerLazySingleton<WardrobeRepository>(
    () => WardrobeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data Source
  sl.registerLazySingleton(() => WardrobeRemoteDataSource(sl()));
}
