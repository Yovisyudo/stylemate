abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String uid;
  final String email;
  final String token;

  AuthAuthenticated({
    required this.uid,
    required this.email,
    required this.token,
  });
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
