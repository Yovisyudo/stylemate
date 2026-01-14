import 'dart:io';
import '../models/user_model.dart';
import '../datasources/profile_remote_data_source.dart';

// Abstract class tidak boleh di-instantiate langsung
abstract class ProfileRepository {
  Future<UserModel> getUserProfile(String token);
  Future<UserModel> updateProfile(
    String token, {
    String? name,
    File? image,
    String? style,
  });
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserModel> getUserProfile(String token) async {
    // Pastikan memanggil remoteDataSource dengan benar
    return await remoteDataSource.getProfile(token);
  }

  @override
  Future<UserModel> updateProfile(
    String token, {
    String? name,
    File? image,
    String? style,
  }) async {
    return await remoteDataSource.updateProfile(
      token,
      name: name,
      image: image,
      style: style,
    );
  }
}
