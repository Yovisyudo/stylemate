import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylemate/features/event/data/models/event_models.dart';

class EventRemoteDataSource {
  final Dio dio;

  EventRemoteDataSource(this.dio);

  // 1. GET ALL EVENTS
  Future<List<EventModel>> getEvents() async {
    try {
      // Ambil UID dari Firebase sebagai identitas
      final String? firebaseUid = FirebaseAuth.instance.currentUser?.uid;

      if (firebaseUid == null) throw Exception("User tidak terautentikasi");

      final response = await dio.get(
        '/events',
        options: Options(
          headers: {
            // Dikirim ke backend untuk diterjemahkan oleh getInternalUserId()
            'Authorization': 'Bearer $firebaseUid',
          },
        ),
      );

      // Backend mengirim data dalam object {'events': [...]}
      final List data = response.data['events'] ?? [];
      return data.map((json) => EventModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? "Gagal mengambil data event",
      );
    }
  }

  // 2. CREATE EVENT
  Future<void> createEvent(EventModel event) async {
    try {
      final String? firebaseUid = FirebaseAuth.instance.currentUser?.uid;

      await dio.post(
        '/events',
        data: event.toJson(), // Mengirim name, description, date, location
        options: Options(headers: {'Authorization': 'Bearer $firebaseUid'}),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Gagal membuat event");
    }
  }

  // lib/features/event/data/datasources/event_remote_data_source.dart

  Future<void> deleteEvent(int eventId) async {
    try {
      final String? firebaseUid = FirebaseAuth.instance.currentUser?.uid;

      await dio.delete(
        '/events/$eventId',
        options: Options(headers: {'Authorization': 'Bearer $firebaseUid'}),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Gagal menghapus event");
    }
  }
}
