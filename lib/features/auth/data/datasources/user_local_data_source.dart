

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/features/wardrobe/data/models/user_model.dart';

class UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSource(this.sharedPreferences);

  Future<void> cacheUser(UserModel user) async {
    try {
      await sharedPreferences.setString(
        'cached_user',
        json.encode(user.toJson()),
      );
    } catch (e) {
      throw const CacheException();
    }
  }

  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString('cached_user');
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString));
      }
      return null;
    } catch (e) {
      throw const CacheException();
    }
  }

  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove('cached_user');
    } catch (e) {
      throw const CacheException();
    }
  }
}