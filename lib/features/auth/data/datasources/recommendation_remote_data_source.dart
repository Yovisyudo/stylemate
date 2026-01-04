import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recommendation_model.dart';

class RecommendationRemoteDataSource {
  final Dio dio;

  static const String _activeIp = "192.168.1.10";
  static const String _baseImageUrl = "http://$_activeIp:8080/uploads/";

  RecommendationRemoteDataSource(this.dio);

  Future<List<RecommendationModel>> getRecommendations(int eventId) async {
    try {
      final String? firebaseUid = FirebaseAuth.instance.currentUser?.uid;

      print('🔵 Fetching recommendations for event: $eventId');

      final response = await dio.get(
        '/recommendations/$eventId',
        options: Options(headers: {'X-Firebase-UID': firebaseUid}),
      );

      dynamic data;
      if (response.data is Map<String, dynamic>) {
        if (response.data.containsKey('recommendations')) {
          data = response.data['recommendations'];
        } else if (response.data.containsKey('data')) {
          data = response.data['data'];
        } else {
          data = response.data;
        }
      } else if (response.data is List) {
        data = response.data;
      } else {
        throw Exception(
          'Format response tidak didukung: ${response.data.runtimeType}',
        );
      }

      if (data is! List) {
        throw Exception('Data bukan array. Type: ${data.runtimeType}');
      }

      final recommendations =
          (data as List).map((json) {
            final Map<String, dynamic> recJson = Map<String, dynamic>.from(
              json,
            );

            // 🔥 FIX UTAMA: perbaiki image di DALAM items
            if (recJson['items'] is List) {
              recJson['items'] =
                  (recJson['items'] as List).map((item) {
                    final Map<String, dynamic> itemJson =
                        Map<String, dynamic>.from(item);

                    String rawUrl =
                        itemJson['image_url'] ?? itemJson['image'] ?? "";

                    rawUrl = rawUrl.toString().trim();

                    if (rawUrl.isNotEmpty) {
                      if (rawUrl.startsWith('http')) {
                        itemJson['image_url'] = rawUrl
                            .replaceAll('localhost', _activeIp)
                            .replaceAll('127.0.0.1', _activeIp);
                      } else {
                        itemJson['image_url'] = _baseImageUrl + rawUrl;
                      }
                    }

                    print('🟢 ITEM IMAGE FINAL: ${itemJson['image_url']}');
                    return itemJson;
                  }).toList();
            }

            return RecommendationModel.fromJson(recJson);
          }).toList();

      print('✅ Berhasil parse ${recommendations.length} recommendation');
      return recommendations;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Gagal memanggil AI');
    }
  }

  // ✅ SEKARANG POSISI SUDAH BENAR
  Future<void> saveOutfit(int eventId, List<int> itemIds) async {
    final String? firebaseUid = FirebaseAuth.instance.currentUser?.uid;
    await dio.post(
      '/save-outfit',
      data: {'event_id': eventId, 'item_ids': itemIds},
      options: Options(headers: {'X-Firebase-UID': firebaseUid}),
    );
  }
}
