import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_tracker/core/error/failures.dart';
import 'package:time_tracker/core/network/dio_client.dart';
import 'package:time_tracker/data/datasources/local/auth_local_datasource.dart';
import 'package:time_tracker/data/datasources/remote/auth_remote_datasource.dart';
import 'package:time_tracker/data/models/auth_result_model.dart';
import 'package:time_tracker/data/models/user_model.dart';
import 'package:time_tracker/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}
class MockDioClient extends Mock implements DioClient {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockDioClient = MockDioClient();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      dioClient: mockDioClient,
    );
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tName = 'Test User';
  const tToken = 'test_token';
  const tUser = UserModel(id: 1, email: tEmail, name: tName);
  const tAuthResult = AuthResultModel(token: tToken, user: tUser);

  group('login', () {
    test('should return AuthResult when login is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => tAuthResult);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenAnswer((_) async => {});
      when(() => mockDioClient.setAuthToken(any())).thenReturn(null);

      // act
      final result = await repository.login(
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result, const Right(tAuthResult));
      verify(() => mockRemoteDataSource.login(
            email: tEmail,
            password: tPassword,
          ));
      verify(() => mockLocalDataSource.saveToken(tToken));
      verify(() => mockDioClient.setAuthToken(tToken));
    });

    test('should return AuthenticationFailure when login fails', () async {
      // arrange
      when(() => mockRemoteDataSource.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(Exception('Invalid credentials'));

      // act
      final result = await repository.login(
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result, const Left(AuthenticationFailure('Invalid credentials')));
      verify(() => mockRemoteDataSource.login(
            email: tEmail,
            password: tPassword,
          ));
      verifyNever(() => mockLocalDataSource.saveToken(any()));
    });
  });

  group('register', () {
    test('should return AuthResult when registration is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.register(
            email: any(named: 'email'),
            password: any(named: 'password'),
            name: any(named: 'name'),
          )).thenAnswer((_) async => tAuthResult);
      when(() => mockLocalDataSource.saveToken(any()))
          .thenAnswer((_) async => {});
      when(() => mockDioClient.setAuthToken(any())).thenReturn(null);

      // act
      final result = await repository.register(
        email: tEmail,
        password: tPassword,
        name: tName,
      );

      // assert
      expect(result, const Right(tAuthResult));
      verify(() => mockRemoteDataSource.register(
            email: tEmail,
            password: tPassword,
            name: tName,
          ));
      verify(() => mockLocalDataSource.saveToken(tToken));
      verify(() => mockDioClient.setAuthToken(tToken));
    });
  });

  group('logout', () {
    test('should clear token and return success', () async {
      // arrange
      when(() => mockLocalDataSource.deleteToken())
          .thenAnswer((_) async => {});
      when(() => mockDioClient.clearAuthToken()).thenReturn(null);

      // act
      final result = await repository.logout();

      // assert
      expect(result, const Right(null));
      verify(() => mockLocalDataSource.deleteToken());
      verify(() => mockDioClient.clearAuthToken());
    });
  });
}
