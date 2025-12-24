import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/features/wardrobe/data/models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSource(this.dio, this.firebaseAuth);

  // ================= LOGIN & SYNC =================
  Future<UserModel> login(String email, String password) async {
    try {
      // 1. Login ke Firebase
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;
      final idToken = await user.getIdToken();

      print("LOG: Login Firebase Sukses. UID: ${user.uid}");
      print("LOG: Mencoba sinkron ke MySQL...");

      // 2. Kirim data ke CI4 (Sesuai Routes: api/auth/login)
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': user.email,
          'uid': user.uid,
          'name': user.displayName ?? 'User Baru',
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      print("LOG: Respon MySQL: ${response.data}");
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      print("LOG ERROR LOGIN: $e");
      throw const ServerException();
    }
  }

  // ================= REGISTER BACKEND =================
  // Digunakan oleh AuthBloc setelah createUserWithEmailAndPassword sukses
  Future<UserModel> registerBackend(
    String token,
    String name,
    String email,
  ) async {
    try {
      print("LOG: Mencoba register ke MySQL...");

      // Sesuaikan endpoint agar konsisten menggunakan grup 'auth'
      final response = await dio.post(
        '/auth/register', // Sebelumnya /api/register, diubah agar sesuai grup routes
        data: {
          'name': name,
          'email': email,
          'uid':
              firebaseAuth
                  .currentUser
                  ?.uid, // Tambahkan UID agar tersimpan di MySQL
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("LOG: Respon Register MySQL: ${response.data}");
      return UserModel.fromJson(response.data['data']);
    } catch (e) {
      print("LOG ERROR REGISTER BACKEND: $e");
      throw const ServerException();
    }
  }

  // Fungsi ini bisa tetap ada jika ingin memisahkan proses register Firebase saja
  Future<String> registerFirebase(String email, String password) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await credential.user!.getIdToken() ?? '';
    } catch (e) {
      print("LOG ERROR REGISTER FIREBASE: $e");
      throw const ServerException();
    }
  }

  // ================= FORGOT PASSWORD =================
  Future<void> forgotPassword(String email) async {
    try {
      // Firebase akan otomatis mengirim email reset password ke alamat ini
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print("LOG ERROR FORGOT PASSWORD: ${e.code}");
      throw const ServerException();
    } catch (e) {
      throw const ServerException();
    }
  }
}
