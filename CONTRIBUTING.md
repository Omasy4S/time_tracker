# Contributing to Time Tracker

## Архитектурные принципы

### Clean Architecture
Проект следует принципам чистой архитектуры:

```
presentation → domain ← data
```

- **Presentation** зависит от **Domain**
- **Data** зависит от **Domain**
- **Domain** не зависит ни от чего

### Слои

#### Domain Layer (Бизнес-логика)
- **Entities**: Чистые бизнес-объекты
- **Repositories**: Интерфейсы (контракты)
- **Use Cases**: Бизнес-логика приложения

#### Data Layer (Данные)
- **Models**: Расширяют entities, добавляют JSON сериализацию
- **Data Sources**: Remote (API) и Local (Storage)
- **Repository Implementations**: Реализация интерфейсов

#### Presentation Layer (UI)
- **BLoC**: State management
- **Pages**: Экраны приложения
- **Widgets**: Переиспользуемые компоненты

## Соглашения по коду

### Именование
- **Classes**: PascalCase (`AuthBloc`, `UserModel`)
- **Files**: snake_case (`auth_bloc.dart`, `user_model.dart`)
- **Variables**: camelCase (`userName`, `isLoading`)
- **Constants**: lowerCamelCase (`apiBaseUrl`)

### BLoC Pattern
```dart
// Event
class LoginEvent extends AuthEvent {
  final String email;
  final String password;
}

// State
class Authenticated extends AuthState {
  final User user;
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    // логика
    emit(Authenticated(user));
  }
}
```

### Repository Pattern
```dart
// Interface в domain
abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> login({...});
}

// Implementation в data
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, AuthResult>> login({...}) async {
    // реализация
  }
}
```

## Добавление новой функции

### 1. Domain Layer
```dart
// 1. Создайте entity
class NewEntity extends Equatable { ... }

// 2. Добавьте метод в repository interface
abstract class SomeRepository {
  Future<Either<Failure, NewEntity>> newMethod();
}

// 3. Создайте use case
class NewUseCase {
  final SomeRepository repository;
  Future<Either<Failure, NewEntity>> call() => repository.newMethod();
}
```

### 2. Data Layer
```dart
// 1. Создайте model
class NewModel extends NewEntity {
  factory NewModel.fromJson(Map<String, dynamic> json) { ... }
}

// 2. Добавьте в data source
abstract class RemoteDataSource {
  Future<NewModel> fetchNew();
}

// 3. Реализуйте в repository
class RepositoryImpl implements SomeRepository {
  @override
  Future<Either<Failure, NewEntity>> newMethod() async {
    try {
      final result = await remoteDataSource.fetchNew();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

### 3. Presentation Layer
```dart
// 1. Создайте events
class NewEvent extends SomeEvent { ... }

// 2. Создайте states
class NewState extends SomeState { ... }

// 3. Обработайте в BLoC
on<NewEvent>(_onNew);

Future<void> _onNew(NewEvent event, Emitter<SomeState> emit) async {
  emit(Loading());
  final result = await useCase();
  result.fold(
    (failure) => emit(Error(failure.message)),
    (data) => emit(Success(data)),
  );
}

// 4. Создайте UI
class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SomeBloc, SomeState>(
      builder: (context, state) { ... }
    );
  }
}
```

## Тестирование

### Unit Tests
```dart
test('should return data when call is successful', () async {
  // arrange
  when(() => mockRepository.method()).thenAnswer((_) async => Right(data));
  
  // act
  final result = await useCase();
  
  // assert
  expect(result, Right(data));
  verify(() => mockRepository.method());
});
```

### BLoC Tests
```dart
blocTest<AuthBloc, AuthState>(
  'should emit [Loading, Success] when login is successful',
  build: () {
    when(() => mockUseCase(...)).thenAnswer((_) async => Right(data));
    return bloc;
  },
  act: (bloc) => bloc.add(LoginEvent(...)),
  expect: () => [Loading(), Success(data)],
);
```

## Git Workflow

### Commit Messages
```
feat: добавлена регистрация пользователей
fix: исправлена ошибка при завершении смены
refactor: рефакторинг AuthBloc
test: добавлены тесты для LoginUseCase
docs: обновлен README
```

### Branch Naming
- `feature/user-registration`
- `fix/shift-finish-bug`
- `refactor/auth-bloc`
- `test/login-usecase`

## Code Review Checklist

- [ ] Код следует Clean Architecture
- [ ] Добавлены необходимые тесты
- [ ] Нет hardcoded значений
- [ ] Обработаны все ошибки
- [ ] UI адаптивен
- [ ] Нет утечек памяти (dispose controllers)
- [ ] Код документирован
- [ ] Проверена работа на разных устройствах

## Полезные команды

```bash
# Анализ кода
flutter analyze

# Форматирование
flutter format .

# Тесты
flutter test

# Покрытие тестами
flutter test --coverage

# Генерация документации
dart doc .
```
