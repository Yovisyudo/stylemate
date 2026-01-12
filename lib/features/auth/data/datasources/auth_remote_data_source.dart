import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSource(this.dio, this.firebaseAuth);

  // ================= LOGIN & SYNC (PERUBAHAN DI SINI) =================
  // Fungsi ini sekarang bertugas sebagai "Gatekeeper & Syncer"
  Future<UserModel> login(String email, String password) async {
    try {
      // 1. Login ke Firebase
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      // 2. CEK VERIFIKASI (Jantung dari Logika Dosen)
      if (!user.emailVerified) {
        await firebaseAuth.signOut(); // Tendang keluar
        throw FirebaseAuthException(
            code: 'email-not-verified',
            message: 'Email belum diverifikasi. Cek inbox Anda.');
      }

      final idToken = await user.getIdToken();

      print("LOG: Login Firebase Sukses & Verified. UID: ${user.uid}");
      print("LOG: Mencoba sinkronisasi data ke MySQL...");

      // 3. Kirim data ke CI4 (Backend harus siap handle: IF NOT EXIST -> INSERT)
      final response = await dio.post(
        '/auth/login', // Pastikan endpoint ini menghandle logic Sync
        data: {
          'email': user.email,
          'uid': user.uid,
          // Kirim nama juga untuk jaga-jaga kalau ini login pertama (sync pertama)
          'name': user.displayName ?? 'User Baru', 
        },
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      print("LOG: Respon MySQL (Sync): ${response.data}");
      return UserModel.fromJson(response.data['data']);
      
    } on FirebaseAuthException catch (e) {
      print("LOG FIREBASE ERROR: ${e.code}");
      rethrow; // Lempar ke Repository
    } catch (e) {
      print("LOG ERROR LOGIN/SYNC: $e");
      throw const ServerException();
    }
  }

  // ================= REGISTER FIREBASE ONLY (REVISI) =================
  // Sekarang Register TIDAK MENGHUBUNGI API MySQL sama sekali
  Future<void> registerFirebaseOnly(String name, String email, String password) async {
    try {
      // 1. Create User
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Update Nama (Supaya saat nanti login pertama, namanya sudah ada)
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        
        // 3. KIRIM VERIFIKASI EMAIL
        await credential.user!.sendEmailVerification();
      }
      
      // 4. Logout (PENTING: Jangan biarkan user masuk sesi)
      await firebaseAuth.signOut();

    } catch (e) {
      print("LOG ERROR REGISTER: $e");
      throw const ServerException();
    }
  }

  // ================= FORGOT PASSWORD =================
  Future<void> forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw const ServerException();
    }
  }
}