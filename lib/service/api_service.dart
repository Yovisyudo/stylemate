import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //static const String baseUrl = 'http://10.0.2.2:8080/api';

  static const String baseUrl = 'http://192.168.1.8:8080/api';
  //Android Emulator: 10.0.2.2
  //Real device: IP laptop (ex: 192.168.1.10)

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) {
    print('Mengirim ke: $baseUrl/$endpoint');
    return http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> get(String endpoint, {String? token}) {
    return http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
