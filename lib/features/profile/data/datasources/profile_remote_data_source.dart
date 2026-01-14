import 'dart:io';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getProfile(String token);
  Future<UserModel> updateProfile(
    String token, {
    String? name,
    File? image,
    String? style,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> getProfile(String token) async {
    try {
      final response = await dio.get(
        '/auth/profile',
        options: Options(
          headers: {'uid': token},
        ), // Sesuaikan jika API pakai header 'uid'
      );
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Gagal memuat profil");
    }
  }

  @override
  Future<UserModel> updateProfile(
    String token, {
    String? name,
    File? image,
    String? style,
  }) async {
    try {
      Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (style != null) data['style_preference'] = style;

      if (image != null) {
        // PERBAIKAN: Key harus 'avatar_url' sesuai PHP
        data['avatar_url'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
      }

      final response = await dio.post(
        '/auth/update-profile',
        data: FormData.fromMap(data),
        options: Options(
          headers: {'uid': token},
        ), // Gunakan header uid sesuai Controller PHP
      );

      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Gagal update profil");
    }
  }
}
