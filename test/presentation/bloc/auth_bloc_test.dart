import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:time_tracker/core/error/failures.dart';
import 'package:time_tracker/domain/entities/auth_result.dart';
import 'package:time_tracker/domain/entities/user.dart';
import 'package:time_tracker/domain/repositories/auth_repository.dart';
import 'package:time_tracker/domain/usecases/login_usecase.dart';
import 'package:time_tracker/domain/usecases/register_usecase.dart';
import 'package:time_tracker/presentation/bloc/auth/auth_bloc.dart';
import 'package:time_tracker/presentation/bloc/auth/auth_event.dart';
import 'package:time_tracker/presentation/bloc/auth/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthBloc bloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockAuthRepository = MockAuthRepository();
    bloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUser = User(id: 1, email: tEmail, name: 'Test User');
  const tAuthResult = AuthResult(token: 'test_token', user: tUser);

  test('initial state should be AuthInitial', () {
    expect(bloc.state, AuthInitial());
  });

  group('LoginEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, Authenticated] when login is successful',
      build: () {
        when(() => mockLoginUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Right(tAuthResult));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoginEvent(
        email: tEmail,
        password: tPassword,
      )),
      expect: () => [
        AuthLoading(),
        const Authenticated(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockLoginUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer(
          (_) async => const Left(AuthenticationFailure('Invalid credentials')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoginEvent(
        email: tEmail,
        password: tPassword,
      )),
      expect: () => [
        AuthLoading(),
        const AuthError('Invalid credentials'),
      ],
    );
  });

  group('LogoutEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [Unauthenticated] when logout is called',
      build: () {
        when(() => mockAuthRepository.logout())
            .thenAnswer((_) async => const Right(null));
        return bloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [Unauthenticated()],
    );
  });
}
