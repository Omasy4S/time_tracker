import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/auth_result.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthResult>> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      name: name,
    );
  }
}
