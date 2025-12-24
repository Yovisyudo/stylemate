import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/core/network/network_info.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:stylemate/features/auth/data/datasources/user_local_data_source.dart';
import 'package:stylemate/features/auth/domain/entities/user.dart';
import 'package:stylemate/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(email, password);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

@override
Future<Either<Failure, User>> register(
  String name,
  String email,
  String password,
) async {
  if (await networkInfo.isConnected) {
    try {
      // 1. Register Firebase
      final token = await remoteDataSource.registerFirebase(
        email,
        password,
      );

      // 2. Register Backend
      final user = await remoteDataSource.registerBackend(
        token,
        name,
        email,
      );

      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException {
      return const Left(ServerFailure());
    }
  } else {
    return const Left(NetworkFailure());
  }
}

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
