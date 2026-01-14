import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String cleanUid = user.uid.trim();

      // Kirim semua jenis header agar kompatibel dengan fitur lama & baru
      options.headers['Authorization'] = 'Bearer $cleanUid';
      options.headers['uid'] = cleanUid;
      options.headers['X-Firebase-UID'] =
          cleanUid; // Penting untuk Lemari/Event
    }

    print("DIO_LOG: [${options.method}] ke ${options.uri}");
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      "DIO_LOG_ERROR: ${err.requestOptions.path} => [${err.response?.statusCode}] ${err.message}",
    );
    return handler.next(err);
  }
}
