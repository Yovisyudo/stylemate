import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/core/network/network_info.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:stylemate/features/auth/data/datasources/user_local_data_source.dart';
import 'package:stylemate/features/auth/domain/entities/user.dart'; // Ini User Entity (Domain)
import 'package:stylemate/features/auth/domain/repositories/auth_repository.dart';

// --- PERBAIKAN IMPORT FIREBASE (Gunakan Alias 'fb') ---
import 'package:firebase_auth/firebase_auth.dart' as fb; 

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
        final userModel = await remoteDataSource.login(email, password);
        await localDataSource.cacheUser(userModel);
        return Right(userModel);
        
      } on fb.FirebaseAuthException catch (e) {
        // Tangani error spesifik jika perlu, atau return ServerFailure umum
        // Jika ServerFailure kamu tidak punya parameter message, hapus 'message: ...'
        return const Left(ServerFailure()); 
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
        await remoteDataSource.registerFirebaseOnly(name, email, password);

        // Return Dummy User (User Entity dari Domain)
        // Pastikan class User kamu punya constructor ini
        return Right(User(
            id: 0, 
            uid: '', // String kosong karena belum sync
            name: name, 
            email: email, 
            stylePreference: '', 
            avatarUrl: ''
        )); 
        
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