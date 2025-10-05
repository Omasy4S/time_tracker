# Flutter Full-Stack Time Tracker

Приложение для учета рабочего времени с чистой архитектурой, построенное на Flutter и Express.js.

## 📱 Описание

Полнофункциональное приложение для отслеживания рабочих смен с возможностью:
- Регистрации и авторизации пользователей
- Начала и завершения рабочих смен
- Добавления отчетов о проделанной работе
- Просмотра истории всех смен
- Отображения длительности активной смены в реальном времени

## 🏗️ Архитектура

Проект следует принципам **Clean Architecture** с разделением на три основных слоя:

```
lib/
├── core/                    # Общие компоненты
│   ├── constants/          # API константы
│   ├── error/              # Обработка ошибок
│   ├── network/            # Dio клиент
│   ├── utils/              # Утилиты (форматирование дат)
│   └── di/                 # Dependency Injection (GetIt)
├── data/                    # Слой данных
│   ├── datasources/        # Источники данных (remote/local)
│   ├── models/             # Модели данных
│   └── repositories/       # Реализация репозиториев
├── domain/                  # Бизнес-логика
│   ├── entities/           # Сущности
│   ├── repositories/       # Интерфейсы репозиториев
│   └── usecases/           # Use cases
└── presentation/            # UI слой
    ├── bloc/               # State management (BLoC)
    ├── pages/              # Экраны приложения
    └── widgets/            # Переиспользуемые виджеты
```

### State Management
Используется **BLoC (Business Logic Component)** для управления состоянием приложения:
- `AuthBloc` - управление аутентификацией
- `ShiftBloc` - управление сменами

### Основные технологии
- **Flutter 3.0+** - фреймворк
- **flutter_bloc** - state management
- **Dio** - HTTP клиент
- **GetIt** - dependency injection
- **flutter_secure_storage** - безопасное хранение токенов
- **Google Fonts** - красивая типографика
- **Dartz** - функциональное программирование (Either)

## 🔌 API

Backend реализован на **Express.js** с in-memory хранилищем данных.

### Эндпоинты

#### Аутентификация
```
POST /auth/register
Body: { "email": "string", "password": "string", "name": "string" }
Response: { "token": "string", "user": { "id": number, "email": "string", "name": "string" } }

POST /auth/login
Body: { "email": "string", "password": "string" }
Response: { "token": "string", "user": { "id": number, "email": "string", "name": "string" } }
```

#### Смены
```
POST /shifts/start
Headers: { "Authorization": "Bearer <token>" }
Response: { "id": number, "userId": number, "startTime": "ISO8601", "status": "active", ... }

PATCH /shifts/finish
Headers: { "Authorization": "Bearer <token>" }
Body: { "report": "string" }
Response: { "id": number, "endTime": "ISO8601", "status": "completed", ... }

GET /shifts
Headers: { "Authorization": "Bearer <token>" }
Response: [{ "id": number, "startTime": "ISO8601", "endTime": "ISO8601", ... }]
```

## 🚀 Запуск проекта

### Требования
- Flutter SDK 3.0+
- Node.js 18+
- Dart 3.0+

### Backend

1. Перейдите в директорию backend:
```bash
cd backend
```

2. Установите зависимости:
```bash
npm install
```

3. Запустите сервер:
```bash
npm start
```

Сервер запустится на `http://localhost:3000`

Для разработки с автоперезагрузкой:
```bash
npm run dev
```

### Flutter приложение

1. Вернитесь в корневую директорию:
```bash
cd ..
```

2. Установите зависимости:
```bash
flutter pub get
```

3. Запустите приложение:
```bash
flutter run
```

Для запуска на конкретном устройстве:
```bash
flutter run -d <device_id>
```

### Docker (опционально)

Для запуска backend в Docker:
```bash
cd backend
docker build -t time-tracker-backend .
docker run -p 3000:3000 time-tracker-backend
```

## 🎨 Особенности UI

- **Material Design 3** - современный дизайн
- **Темная тема** - автоматическое переключение по системным настройкам
- **Адаптивная верстка** - корректное отображение на разных размерах экранов
- **Анимации** - плавные переходы и обновления
- **Градиенты** - красивые карточки статуса смены
- **Иконки** - интуитивно понятный интерфейс

## 📱 Экраны

1. **Экран авторизации** - вход и регистрация
2. **Экран "Моя смена"** - управление текущей сменой
3. **Экран "История"** - список всех смен с деталями

## ✅ Реализованный функционал

- ✅ Регистрация и авторизация пользователей
- ✅ JWT токены для аутентификации
- ✅ Безопасное хранение токенов (flutter_secure_storage)
- ✅ Начало рабочей смены
- ✅ Завершение смены с отчетом
- ✅ Отображение активной смены в реальном времени
- ✅ История всех смен
- ✅ Обработка ошибок и состояний загрузки
- ✅ Валидация форм
- ✅ Pull-to-refresh
- ✅ Темная тема
- ✅ Clean Architecture
- ✅ BLoC pattern
- ✅ Dependency Injection

## 🔧 Что можно улучшить

### Функциональность
- Добавить офлайн-режим с локальным кэшем (Hive/Drift)
- Реализовать редактирование завершенных смен
- Добавить статистику и графики
- Экспорт данных в CSV/PDF
- Push-уведомления о длительных сменах
- Биометрическая аутентификация

### Backend
- Использовать реальную БД (PostgreSQL/MongoDB)
- Добавить валидацию данных
- Реализовать refresh tokens
- Добавить rate limiting
- Логирование и мониторинг
- Unit и integration тесты

### Тестирование
- Unit тесты для use cases
- Widget тесты для UI
- Integration тесты
- Тесты BLoC (bloc_test)

### DevOps
- CI/CD pipeline
- Деплой backend на Render/Railway
- Деплой Flutter Web на Vercel/Netlify

## 📝 Структура БД (in-memory)

### Users
```javascript
{
  id: number,
  email: string,
  password: string (hashed),
  name: string,
  createdAt: ISO8601
}
```

### Shifts
```javascript
{
  id: number,
  userId: number,
  startTime: ISO8601,
  endTime: ISO8601 | null,
  report: string | null,
  status: 'active' | 'completed',
  createdAt: ISO8601
}
```

## 🔐 Безопасность

- Пароли хешируются с помощью bcryptjs
- JWT токены для аутентификации
- Токены хранятся в flutter_secure_storage
- Валидация на клиенте и сервере
- CORS настроен для безопасности

## 📄 Лицензия

MIT

## 👨‍💻 Автор

Создано как тестовое задание для позиции Full-Stack Flutter Developer
