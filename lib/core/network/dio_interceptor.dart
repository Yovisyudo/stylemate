import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Ambil UID dari Firebase Auth yang sedang login
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      // Otomatis tempelkan ke header untuk setiap request
      options.headers['Authorization'] = 'Bearer ${uid.trim()}';
    }

    print("DIO_LOG: Mengirim request ke ${options.path}");
    return handler.next(options);
  }
}
