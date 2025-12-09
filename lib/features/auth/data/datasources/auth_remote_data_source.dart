

import 'package:dio/dio.dart';
import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/features/wardrobe/data/models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post('/api/login', data: {
        'email': email,
        'password': password,
      });
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw const ServerException();
      }
    } catch (e) {
      throw const ServerException();
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await dio.post('/api/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      
      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        throw const ServerException();
      }
    } catch (e) {
      throw const ServerException();
    }
  }
}
