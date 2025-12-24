import 'package:dio/dio.dart';
import 'package:stylemate/features/wardrobe/data/models/wardrobe_model.dart';

class WardrobeRemoteDataSource {
  final Dio dio;

  // Tambahkan konstanta base URL untuk gambar
  // Sesuaikan IP 172.20.8.25 dengan IP laptop Anda saat ini
  static const String _baseImageUrl = "https://b89d6b158bc4.ngrok-free.app/uploads/";

  WardrobeRemoteDataSource(this.dio);

  Future<List<WardrobeItemModel>> getWardrobe() async {
    try {
      final response = await dio.get('/wardrobe');

      return (response.data as List).map((e) {
        // Manipulasi data JSON sebelum dikonversi ke Model
        final Map<String, dynamic> itemJson = Map<String, dynamic>.from(e);

        // Cek jika ada image_url, gabungkan dengan base URL
        if (itemJson['image_url'] != null &&
            itemJson['image_url'].toString().isNotEmpty) {
          itemJson['image_url'] = _baseImageUrl + itemJson['image_url'];
        }

        return WardrobeItemModel.fromJson(itemJson);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addWardrobe(Map<String, dynamic> data) async {
    try {
      // Pastikan key "image" sesuai dengan yang diharapkan Controller CI4 Anda
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

  // 3. PUT (Update/Edit baju)
  Future<void> updateWardrobe(int id, Map<String, dynamic> data) async {
    try {
      // Karena update di backend menerima JSON
      await dio.put('/wardrobe/$id', data: data);
    } catch (e) {
      rethrow;
    }
  }

  // 4. DELETE (Hapus baju)
  Future<void> deleteWardrobe(int id) async {
    try {
      await dio.delete('/wardrobe/$id');
    } catch (e) {
      rethrow;
    }
  }
}
