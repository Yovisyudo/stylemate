import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/auth_remote_data_source.dart'; 
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth firebaseAuth;
  final AuthRemoteDataSource authRemoteDataSource; // Sebenarnya akses lewat Repository lebih clean, tapi kita ikuti strukturmu.

  AuthBloc({required this.firebaseAuth, required this.authRemoteDataSource})
      : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
    // on<ForgotPasswordEvent>(_onForgotPassword); // Un-comment jika ada
  }

  // ==========================
  // LOGIN (DENGAN CEK VERIFIKASI)
  // ==========================
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // Panggil fungsi login di DataSource yang sudah kita revisi
      // Fungsi ini akan throw error jika email belum verified
      final userModel = await authRemoteDataSource.login(event.email, event.password);
      
      // Ambil token untuk session
      final currentUser = firebaseAuth.currentUser;
      final token = await currentUser?.getIdToken() ?? '';

      // Jika sukses sampai sini, artinya: 
      // 1. Password benar 
      // 2. Email verified 
      // 3. Data sudah di-sync ke MySQL
      
      emit(AuthAuthenticated(
        uid: userModel.uid ?? currentUser!.uid, 
        email: userModel.email, 
        token: token
      ));

    } on FirebaseAuthException catch (e) {
       // Tangkap error khusus verifikasi
       if (e.code == 'email-not-verified') {
         emit(AuthError(message: 'Email belum diverifikasi. Silakan cek inbox email Anda.'));
       } else {
         emit(AuthError(message: _mapFirebaseError(e)));
       }
    } catch (e) {
      emit(AuthError(message: 'Gagal Login: $e'));
    }
  }

  // ==========================
  // REGISTER (FIREBASE ONLY)
  // ==========================
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // Panggil fungsi register yang baru (Cuma Firebase + Kirim Email)
      await authRemoteDataSource.registerFirebaseOnly(
        event.name, 
        event.email, 
        event.password
      );

      // PENTING: Jangan emit AuthAuthenticated!
      // Emit state khusus atau error message yang memberitahu sukses tapi harus verifikasi.
      // Cara hacky (biar ga ubah banyak UI): Emit AuthError tapi isinya pesan sukses (atau buat state baru AuthRegisterSuccess)
      
      emit(AuthError(message: 'Registrasi Berhasil! Silakan cek email Anda untuk verifikasi sebelum Login.'));
      
      // Setelah user baca pesan, UI akan kembali ke posisi awal (Login Screen)

    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError(message: 'Gagal Mendaftar. Coba lagi nanti.'));
    }
  }

  // ... (Sisa fungsi Logout, CheckAuth, mapError tetap sama) ...
   Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await firebaseAuth.signOut();
    emit(AuthInitial());
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      emit(AuthInitial());
    } else {
      // Reload user untuk memastikan status emailVerified terbaru
      await user.reload(); 
      if(user.emailVerified){
         final token = await user.getIdToken();
         emit(AuthAuthenticated(uid: user.uid, email: user.email!, token: token!));
      } else {
        // Kalau sesi masih nyangkut tapi belum verified (kasus langka), logoutkan
        await firebaseAuth.signOut();
        emit(AuthInitial());
      }
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'User tidak ditemukan';
      case 'wrong-password': return 'Password salah';
      case 'email-already-in-use': return 'Email sudah terdaftar';
      case 'weak-password': return 'Password terlalu lemah';
      case 'invalid-email': return 'Format email tidak valid';
      default: return e.message ?? 'Terjadi kesalahan autentikasi';
    }
  }
}