import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth firebaseAuth;
  final AuthRemoteDataSource authRemoteDataSource;

  AuthBloc({required this.firebaseAuth, required this.authRemoteDataSource})
    : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  // ==========================
  // LOGIN (FIXED: Added name)
  // ==========================
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // 1. Login via Remote Data Source (MySQL/API)
      final userModel = await authRemoteDataSource.login(
        event.email,
        event.password,
      );

      // 2. Ambil token Firebase
      final currentUser = firebaseAuth.currentUser;
      final token = await currentUser?.getIdToken() ?? '';

      // 3. Emit Authenticated dengan NAMA
      emit(
        AuthAuthenticated(
          uid: userModel.uid ?? currentUser!.uid,
          email: userModel.email,
          token: token,
          name:
              userModel
                  .name, // <--- TAMBAHAN: Ambil nama dari response database
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-not-verified') {
        emit(
          AuthError(
            message: 'Email belum diverifikasi. Silakan cek inbox email Anda.',
          ),
        );
      } else {
        emit(AuthError(message: _mapFirebaseError(e)));
      }
    } catch (e) {
      emit(AuthError(message: 'Gagal Login: $e'));
    }
  }

  // ==========================
  // REGISTER
  // ==========================
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await authRemoteDataSource.registerFirebaseOnly(
        event.name,
        event.email,
        event.password,
      );

      // Kita update nama di profile Firebase agar saat CheckAuth nanti namanya muncul
      if (firebaseAuth.currentUser != null) {
        await firebaseAuth.currentUser!.updateDisplayName(event.name);
      }

      emit(
        AuthError(
          message:
              'Registrasi Berhasil! Silakan cek email Anda untuk verifikasi sebelum Login.',
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError(message: 'Gagal Mendaftar. Coba lagi nanti.'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await firebaseAuth.signOut();
    emit(AuthInitial());
  }

  // ==========================
  // CHECK AUTH (FIXED: Added name)
  // ==========================
  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      emit(AuthInitial());
    } else {
      await user.reload();
      if (user.emailVerified) {
        final token = await user.getIdToken();

        // Ambil nama dari Firebase Profile (displayName)
        // Kalau null, pakai default "User"
        final String displayName = user.displayName ?? "User";

        emit(
          AuthAuthenticated(
            uid: user.uid,
            email: user.email!,
            token: token!,
            name: displayName, // <--- TAMBAHAN: Masukkan nama di sini
          ),
        );
      } else {
        await firebaseAuth.signOut();
        emit(AuthInitial());
      }
    }
  }

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
}
