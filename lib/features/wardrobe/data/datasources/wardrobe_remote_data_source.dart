

import 'package:dio/dio.dart';
import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/features/auth/data/models/wadrobe_item_model.dart';

class WardrobeRemoteDataSource {
  final Dio dio;

  WardrobeRemoteDataSource(this.dio);

  Future<List<WardrobeItemModel>> getWardrobe() async {
    try {
      final response = await dio.get('/api/wardrobe');
      
      if (response.statusCode == 200) {
        final List items = response.data['items'];
        return items.map((json) => WardrobeItemModel.fromJson(json)).toList();
      } else {
        throw const ServerException();
      }
    } catch (e) {
      throw const ServerException();
    }
  }

  Future<WardrobeItemModel> addItem(WardrobeItemModel item) async {
    try {
      final response = await dio.post('/api/wardrobe', data: item.toJson());
      
      if (response.statusCode == 201) {
        return WardrobeItemModel.fromJson(response.data);
      } else {
        throw const ServerException();
      }
    } catch (e) {
      throw const ServerException();
    }
  }
}