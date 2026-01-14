abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String uid;
  final String email;
  final String token;
  final String name; // <--- TAMBAHKAN INI

  AuthAuthenticated({
    required this.uid,
    required this.email,
    required this.token,
    required this.name, // <--- TAMBAHKAN INI
  });
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}