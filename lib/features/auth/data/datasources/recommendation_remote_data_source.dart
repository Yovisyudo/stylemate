import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylemate/features/auth/domain/entities/recommendation.dart';
import '../models/recommendation_model.dart';

class RecommendationRemoteDataSource {
  final Dio dio;

  static const String _activeIp = "10.42.189.26";
  static const String _baseImageUrl = "http://$_activeIp:8080/uploads/";

  RecommendationRemoteDataSource(this.dio);

  @override
  Future<List<Recommendation>> getRecommendations(int eventId) async {
    try {
      final response = await dio.get('/recommendations/$eventId');

      // 1️⃣ Validasi response
      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw Exception('Response tidak valid');
      }

      final Map<String, dynamic> body = Map<String, dynamic>.from(
        response.data,
      );

      // 2️⃣ Ambil array recommendations
      if (!body.containsKey('recommendations') ||
          body['recommendations'] is! List) {
        throw Exception('Key "recommendations" tidak ditemukan');
      }

      final List rawList = body['recommendations'];

      // 3️⃣ Parse ke Model (Model EXTENDS Entity)
      final List<Recommendation> recommendations =
          rawList.map((json) {
            return RecommendationModel.fromJson(
              Map<String, dynamic>.from(json),
            );
          }).toList();

      return recommendations;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Gagal mengambil recommendation',
      );
    } catch (e) {
      throw Exception('Parsing recommendation gagal: $e');
    }
  }

  Future<void> saveOutfit(int eventId, List<int> itemIds) async {
    final String? firebaseUid = FirebaseAuth.instance.currentUser?.uid;

    await dio.post(
      '/save-outfit',
      data: {'event_id': eventId, 'item_ids': itemIds},
      options: Options(headers: {'X-Firebase-UID': firebaseUid}),
    );
  }
}
