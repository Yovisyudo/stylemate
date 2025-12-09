
import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/auth/domain/entities/user.dart';
import 'package:stylemate/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      params.name,
      params.email,
      params.password,
    );
  }
}

class RegisterParams {
  final String name;
  final String email;
  final String password;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
}