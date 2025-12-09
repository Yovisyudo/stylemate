

import 'package:stylemate/core/error/failures.dart';
import 'package:stylemate/core/utils/either.dart';
import 'package:stylemate/features/auth/domain/entities/user.dart';
import 'package:stylemate/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}