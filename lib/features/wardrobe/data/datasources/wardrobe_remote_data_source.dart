import 'package:dio/dio.dart';
import 'package:stylemate/features/wardrobe/data/models/wardrobe_model.dart';

class WardrobeRemoteDataSource {
  final Dio dio;

  static const String _activeIp = "192.168.1.8";
  static const String _baseImageUrl = "http://$_activeIp:8080/uploads/";

  WardrobeRemoteDataSource(this.dio);

  Future<List<WardrobeItemModel>> getWardrobe() async {
    try {
      final response = await dio.get('/wardrobe');

      return (response.data as List).map((e) {
        final Map<String, dynamic> itemJson = Map<String, dynamic>.from(e);

        String rawUrl = itemJson['image_url']?.toString().trim() ?? "";

        if (rawUrl.isNotEmpty) {
          if (rawUrl.startsWith('http')) {
            // Normalisasi semua URL lama
            itemJson['image_url'] = rawUrl
                .replaceAll('localhost', _activeIp)
                .replaceAll('10.42.189.26', _activeIp);
          } else {
            // Kalau cuma nama file
            itemJson['image_url'] = _baseImageUrl + rawUrl;
          }
        }

        // DEBUG (boleh dihapus nanti)
        print("IMAGE FINAL: ${itemJson['image_url']}");

        return WardrobeItemModel.fromJson(itemJson);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addWardrobe(Map<String, dynamic> data) async {
    try {
      FormData formData = FormData.fromMap({
        "name": data['name'],
        "category_id": data['category_id'],
        "color": data['color'],
        "style": data['style'],
        "image": await MultipartFile.fromFile(data['image_path']),
      });

      await dio.post('/wardrobe', data: formData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateWardrobe(int id, Map<String, dynamic> data) async {
    try {
      await dio.put('/wardrobe/$id', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWardrobe(int id) async {
    try {
      await dio.delete('/wardrobe/$id');
    } catch (e) {
      rethrow;
    }
  }
}
