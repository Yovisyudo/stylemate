import 'package:dio/dio.dart';
import 'package:stylemate/features/wardrobe/data/models/wardrobe_model.dart';

class WardrobeRemoteDataSource {
  final Dio dio;

  // Tambahkan konstanta base URL untuk gambar
  // Sesuaikan IP 172.20.8.25 dengan IP laptop Anda saat ini
  static const String _baseImageUrl = "http://10.42.189.26:8080/uploads/";

  WardrobeRemoteDataSource(this.dio);

  // wardrobe_remote_data_source.dart
  // lib/features/wardrobe/data/datasources/wardrobe_remote_data_source.dart

Future<List<WardrobeItemModel>> getWardrobe() async {
  try {
    final response = await dio.get('/wardrobe');

    return (response.data as List).map((e) {
      final Map<String, dynamic> itemJson = Map<String, dynamic>.from(e);
      String rawUrl = itemJson['image_url']?.toString().trim() ?? "";

      if (rawUrl.isNotEmpty) {
        // Jika DB menyimpan URL lengkap (seperti di gambar database Anda)
        if (rawUrl.startsWith('http://localhost')) {
          // Ganti 'localhost' menjadi IP laptop agar bisa diakses HP Infinix
          itemJson['image_url'] = rawUrl.replaceAll('localhost', '10.42.189.26');
        } 
        // Jika DB hanya menyimpan nama file
        else if (!rawUrl.startsWith('http')) {
          itemJson['image_url'] = _baseImageUrl + rawUrl;
        }
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
