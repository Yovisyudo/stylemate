abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  // Gunakan kurung kurawal agar sinkron dengan LoginPage kamu
  ForgotPasswordEvent({required this.email});
}

class LogoutEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}
