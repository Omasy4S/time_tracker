# Архитектура проекта Time Tracker

## Обзор

Проект построен на основе **Clean Architecture** с использованием **BLoC** для управления состоянием.

## Диаграмма слоев

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, BLoC, Pages, Widgets)            │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│          Domain Layer                   │
│  (Entities, Use Cases, Repositories)    │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│           Data Layer                    │
│  (Models, Data Sources, Repositories)   │
└─────────────────────────────────────────┘
```

## Структура директорий

```
lib/
├── core/                           # Общие компоненты
│   ├── constants/                  # Константы приложения
│   │   ├── api_constants.dart     # API endpoints
│   │   └── app_constants.dart     # Общие константы
│   ├── di/                        # Dependency Injection
│   │   └── injection_container.dart
│   ├── error/                     # Обработка ошибок
│   │   └── failures.dart
│   ├── network/                   # Сетевой слой
│   │   └── dio_client.dart
│   ├── theme/                     # Темы приложения
│   │   └── app_theme.dart
│   └── utils/                     # Утилиты
│       ├── date_formatter.dart
│       └── validators.dart
│
├── data/                          # Слой данных
│   ├── datasources/
│   │   ├── local/                # Локальное хранилище
│   │   │   └── auth_local_datasource.dart
│   │   └── remote/               # API запросы
│   │       ├── auth_remote_datasource.dart
│   │       └── shift_remote_datasource.dart
│   ├── models/                   # Модели данных
│   │   ├── auth_result_model.dart
│   │   ├── shift_model.dart
│   │   └── user_model.dart
│   └── repositories/             # Реализация репозиториев
│       ├── auth_repository_impl.dart
│       └── shift_repository_impl.dart
│
├── domain/                        # Бизнес-логика
│   ├── entities/                 # Бизнес-сущности
│   │   ├── auth_result.dart
│   │   ├── shift.dart
│   │   └── user.dart
│   ├── repositories/             # Интерфейсы репозиториев
│   │   ├── auth_repository.dart
│   │   └── shift_repository.dart
│   └── usecases/                 # Use Cases
│       ├── finish_shift_usecase.dart
│       ├── get_shifts_usecase.dart
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── start_shift_usecase.dart
│
└── presentation/                  # UI слой
    ├── bloc/                     # State Management
    │   ├── auth/
    │   │   ├── auth_bloc.dart
    │   │   ├── auth_event.dart
    │   │   └── auth_state.dart
    │   └── shift/
    │       ├── shift_bloc.dart
    │       ├── shift_event.dart
    │       └── shift_state.dart
    ├── pages/                    # Экраны
    │   ├── auth/
    │   │   ├── login_page.dart
    │   │   └── register_page.dart
    │   └── home/
    │       ├── history_page.dart
    │       ├── home_page.dart
    │       └── shift_page.dart
    └── widgets/                  # Переиспользуемые виджеты
        ├── custom_button.dart
        └── custom_text_field.dart
```

## Принципы архитектуры

### 1. Dependency Rule
Зависимости направлены внутрь:
- **Presentation** → **Domain**
- **Data** → **Domain**
- **Domain** ← независим

### 2. Separation of Concerns
Каждый слой имеет свою ответственность:
- **Domain**: Бизнес-логика
- **Data**: Получение и хранение данных
- **Presentation**: Отображение UI

### 3. Dependency Inversion
Используем интерфейсы (abstract classes) для инверсии зависимостей.

## Поток данных

### Пример: Авторизация пользователя

```
1. User нажимает кнопку "Войти"
   ↓
2. LoginPage вызывает AuthBloc
   ↓
3. AuthBloc.add(LoginEvent)
   ↓
4. AuthBloc вызывает LoginUseCase
   ↓
5. LoginUseCase вызывает AuthRepository
   ↓
6. AuthRepositoryImpl вызывает AuthRemoteDataSource
   ↓
7. AuthRemoteDataSource делает HTTP запрос через Dio
   ↓
8. Получает ответ и преобразует в AuthResultModel
   ↓
9. AuthRepositoryImpl сохраняет токен через AuthLocalDataSource
   ↓
10. Возвращает Either<Failure, AuthResult>
   ↓
11. AuthBloc.emit(Authenticated(user))
   ↓
12. LoginPage получает новое состояние и обновляет UI
```

## State Management (BLoC)

### Структура BLoC

```dart
// Event - что произошло
abstract class AuthEvent {}
class LoginEvent extends AuthEvent {
  final String email;
  final String password;
}

// State - текущее состояние
abstract class AuthState {}
class AuthLoading extends AuthState {}
class Authenticated extends AuthState {
  final User user;
}
class AuthError extends AuthState {
  final String message;
}

// BLoC - обработчик событий
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  on<LoginEvent>(_onLogin);
  
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(email: event.email, password: event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (authResult) => emit(Authenticated(authResult.user)),
    );
  }
}
```

## Dependency Injection

Используется **GetIt** для управления зависимостями:

```dart
// Регистрация
sl.registerFactory(() => AuthBloc(loginUseCase: sl(), ...));
sl.registerLazySingleton(() => LoginUseCase(sl()));
sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(...));

// Использование
final authBloc = sl<AuthBloc>();
```

## Обработка ошибок

### Either Pattern (dartz)

```dart
// Success
return Right(data);

// Failure
return Left(ServerFailure('Error message'));

// Использование
result.fold(
  (failure) => handleError(failure),
  (data) => handleSuccess(data),
);
```

### Типы ошибок

- **ServerFailure**: Ошибки сервера
- **NetworkFailure**: Проблемы с сетью
- **CacheFailure**: Ошибки локального хранилища
- **AuthenticationFailure**: Ошибки аутентификации

## Модели vs Entities

### Entity (Domain)
```dart
class User extends Equatable {
  final int id;
  final String email;
  final String name;
}
```

### Model (Data)
```dart
class UserModel extends User {
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
  
  Map<String, dynamic> toJson() => {...};
}
```

## Тестирование

### Unit Tests
- Use Cases
- Repositories
- Data Sources

### BLoC Tests
- Events → States
- Используется `bloc_test` пакет

### Widget Tests
- UI компоненты
- Интеграция с BLoC

## Преимущества архитектуры

✅ **Тестируемость**: Каждый слой тестируется независимо
✅ **Масштабируемость**: Легко добавлять новые функции
✅ **Поддерживаемость**: Чистое разделение ответственности
✅ **Независимость**: Domain не зависит от фреймворков
✅ **Гибкость**: Легко заменить источники данных

## Backend Architecture

```
Express.js Server
├── Routes
│   ├── /auth/*
│   └── /shifts/*
├── Middleware
│   └── authenticateToken
├── In-Memory Storage
│   ├── users[]
│   └── shifts[]
└── JWT Authentication
```

## Безопасность

- JWT токены для аутентификации
- bcryptjs для хеширования паролей
- flutter_secure_storage для хранения токенов
- HTTPS для production

## Производительность

- Lazy loading зависимостей (GetIt)
- Кэширование токенов
- Оптимизированные запросы к API
- Минимальные перерисовки UI (BLoC)

## Будущие улучшения

- Добавить Hive для офлайн-режима
- Реализовать refresh tokens
- Добавить аналитику
- Миграция на реальную БД (PostgreSQL)
