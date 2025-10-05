import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/auth_result.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResult>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, void>> logout();

  Future<String?> getToken();
  
  Future<bool> isAuthenticated();
}
