import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_tracker/core/error/failures.dart';
import 'package:time_tracker/domain/entities/auth_result.dart';
import 'package:time_tracker/domain/entities/user.dart';
import 'package:time_tracker/domain/repositories/auth_repository.dart';
import 'package:time_tracker/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUser = User(id: 1, email: tEmail, name: 'Test User');
  const tAuthResult = AuthResult(token: 'test_token', user: tUser);

  test('should get auth result from the repository', () async {
    // arrange
    when(() => mockAuthRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => const Right(tAuthResult));

    // act
    final result = await useCase(email: tEmail, password: tPassword);

    // assert
    expect(result, const Right(tAuthResult));
    verify(() => mockAuthRepository.login(email: tEmail, password: tPassword));
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when login fails', () async {
    // arrange
    when(() => mockAuthRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer(
      (_) async => const Left(AuthenticationFailure('Invalid credentials')),
    );

    // act
    final result = await useCase(email: tEmail, password: tPassword);

    // assert
    expect(result, const Left(AuthenticationFailure('Invalid credentials')));
    verify(() => mockAuthRepository.login(email: tEmail, password: tPassword));
  });
}
