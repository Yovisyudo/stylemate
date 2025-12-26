import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/auth_remote_data_source.dart'; // Sesuaikan path ini
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth firebaseAuth;

  final AuthRemoteDataSource
  authRemoteDataSource; // Instance member untuk akses ke MySQL

  AuthBloc({required this.firebaseAuth, required this.authRemoteDataSource})
    : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
    on<ForgotPasswordEvent>(_onForgotPassword);
  }

  // ==========================
  // LOGIN & SYNC TO MYSQL
  // ==========================
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // 1. Login ke Firebase Auth
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final user = credential.user!;
      final token = await user.getIdToken();

      // 2. Sinkronisasi ke Database MySQL via CI4
      // Memanggil fungsi login pada instance authRemoteDataSource
      await authRemoteDataSource.login(event.email, event.password);

      emit(AuthAuthenticated(uid: user.uid, email: user.email!, token: token!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _mapFirebaseError(e)));
    } catch (e) {
      // Jika error terjadi pada tahap sinkronisasi MySQL (misal: IP Laptop salah)
      emit(AuthError(message: 'Gagal sinkronisasi data ke server: $e'));
    }
  }

  // ==========================
  // REGISTER & SYNC TO MYSQL
  // ==========================
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // 1. Register akun baru di Firebase
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final user = credential.user!;
      await user.updateDisplayName(event.name);
      final token = await user.getIdToken();

      // 2. Simpan data ke Database MySQL
      // Menggunakan token Firebase untuk autentikasi di sisi backend CI4
      await authRemoteDataSource.registerBackend(
        token!,
        event.name,
        event.email,
      );

      emit(AuthAuthenticated(uid: user.uid, email: user.email!, token: token));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError(message: 'Gagal mendaftarkan user ke server lokal'));
    }
  }

  // ==========================
  // LOGOUT
  // ==========================
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await firebaseAuth.signOut();
    emit(AuthInitial());
  }

  // ==========================
  // AUTO LOGIN (CHECK AUTH)
  // ==========================
  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      emit(AuthInitial());
    } else {
      final token = await user.getIdToken(true);
      print('🔥 FIREBASE ID TOKEN 🔥');
      print(token);

      emit(AuthAuthenticated(uid: user.uid, email: user.email!, token: token!));
    }
  }

  // ==========================
  // FIREBASE ERROR MAPPING
  // ==========================
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'User tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'weak-password':
        return 'Password terlalu lemah';
      case 'invalid-email':
        return 'Format email tidak valid';
      default:
        return e.message ?? 'Terjadi kesalahan autentikasi';
    }
  }

  // Daftarkan di constructor

  // Logic handler
  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRemoteDataSource.forgotPassword(event.email);
      // Kita bisa buat State baru 'AuthEmailSent' atau gunakan AuthInitial dengan pesan sukses
      emit(AuthInitial());
    } catch (e) {
      emit(
        AuthError(
          message:
              'Gagal mengirim email reset password. Pastikan email terdaftar.',
        ),
      );
    }
  }
}
