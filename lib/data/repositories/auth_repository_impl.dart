import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/network/dio_client.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final DioClient dioClient;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.dioClient,
  });

  @override
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );
      
      await localDataSource.saveToken(result.token);
      dioClient.setAuthToken(result.token);
      
      return Right(result);
    } on Exception catch (e) {
      return Left(AuthenticationFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final result = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      
      await localDataSource.saveToken(result.token);
      dioClient.setAuthToken(result.token);
      
      return Right(result);
    } on Exception catch (e) {
      return Left(AuthenticationFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      dioClient.clearAuthToken();
      return const Right(null);
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await localDataSource.getToken();
    if (token != null) {
      dioClient.setAuthToken(token);
      return true;
    }
    return false;
  }
}
