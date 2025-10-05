# 🚀 Инструкция по запуску Time Tracker

Пошаговое руководство для запуска проекта с нуля.

## Предварительные требования

Убедитесь, что у вас установлено:

- ✅ **Flutter SDK 3.0+** - [Установить Flutter](https://flutter.dev/docs/get-started/install)
- ✅ **Node.js 18+** - [Установить Node.js](https://nodejs.org/)
- ✅ **Git** - для клонирования репозитория
- ✅ **Android Studio** или **Xcode** (для запуска на эмуляторе)

## Проверка установки

```bash
# Проверка Flutter
flutter --version
flutter doctor

# Проверка Node.js
node --version
npm --version
```

## Шаг 1: Клонирование проекта

```bash
git clone <your-repository-url>
cd time_tracker
```

## Шаг 2: Запуск Backend

### 2.1 Установка зависимостей

```bash
cd backend
npm install
```

### 2.2 Настройка переменных окружения

Файл `.env` уже создан с настройками по умолчанию:
```
PORT=3000
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
```

**⚠️ Важно:** Для production измените `JWT_SECRET` на свой уникальный ключ!

### 2.3 Запуск сервера

```bash
# Production режим
npm start

# Development режим (с автоперезагрузкой)
npm run dev
```

✅ Сервер запустится на `http://localhost:3000`

Проверьте работу:
```bash
curl http://localhost:3000/health
```

Должен вернуть: `{"status":"OK","timestamp":"..."}`

## Шаг 3: Запуск Flutter приложения

### 3.1 Откройте новый терминал

**Важно:** Backend должен продолжать работать в первом терминале!

```bash
cd ..  # Вернитесь в корневую директорию
```

### 3.2 Установка зависимостей Flutter

```bash
flutter pub get
```

### 3.3 Проверка доступных устройств

```bash
flutter devices
```

### 3.4 Запуск приложения

#### На Android эмуляторе:
```bash
flutter run
```

#### На конкретном устройстве:
```bash
flutter run -d <device_id>
```

#### На Chrome (Web):
```bash
flutter run -d chrome
```

## Шаг 4: Тестирование приложения

### 4.1 Регистрация нового пользователя

1. Откройте приложение
2. Нажмите "Зарегистрироваться"
3. Заполните форму:
   - **Имя:** Иван Иванов
   - **Email:** ivan@test.com
   - **Пароль:** 123456
4. Нажмите "Зарегистрироваться"

### 4.2 Работа со сменами

1. На экране "Моя смена" нажмите **"Начать смену"**
2. Смена начнется, таймер покажет длительность
3. Нажмите **"Завершить смену"**
4. Введите отчет о работе
5. Перейдите на вкладку **"История"** - увидите завершенную смену

### 4.3 Выход из аккаунта

Нажмите иконку выхода в правом верхнем углу

## Шаг 5: Запуск тестов (опционально)

### Backend тесты
```bash
cd backend
npm test  # если добавите тесты
```

### Flutter тесты
```bash
cd ..
flutter test
```

## Возможные проблемы и решения

### ❌ Проблема: "Connection refused" в приложении

**Решение:**
- Убедитесь, что backend запущен (`npm start`)
- Проверьте, что сервер работает на порту 3000
- Для Android эмулятора используйте `http://10.0.2.2:3000` вместо `localhost`

Измените в `lib/core/constants/api_constants.dart`:
```dart
static const String baseUrl = 'http://10.0.2.2:3000'; // для Android
```

### ❌ Проблема: Flutter не находит устройства

**Решение:**
```bash
# Запустите Android эмулятор через Android Studio
# Или подключите физическое устройство с включенной отладкой по USB

flutter doctor  # проверьте проблемы
```

### ❌ Проблема: Ошибки при `flutter pub get`

**Решение:**
```bash
flutter clean
flutter pub get
```

### ❌ Проблема: Backend не запускается

**Решение:**
```bash
# Проверьте, что порт 3000 свободен
# Windows:
netstat -ano | findstr :3000

# Удалите node_modules и переустановите
rm -rf node_modules
npm install
```

## Docker (альтернативный способ запуска backend)

```bash
cd backend
docker build -t time-tracker-backend .
docker run -p 3000:3000 time-tracker-backend
```

## Структура API для тестирования

### Регистрация
```bash
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"123456","name":"Test User"}'
```

### Вход
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"123456"}'
```

### Начать смену (требуется токен)
```bash
curl -X POST http://localhost:3000/shifts/start \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## Полезные команды

```bash
# Flutter
flutter clean              # Очистка кэша
flutter pub get           # Установка зависимостей
flutter run --release     # Запуск в release режиме
flutter build apk         # Сборка APK для Android

# Backend
npm start                 # Запуск сервера
npm run dev              # Запуск с автоперезагрузкой
```

## Следующие шаги

После успешного запуска вы можете:

1. ✅ Изучить архитектуру проекта в `README.md`
2. ✅ Посмотреть код в `lib/` директории
3. ✅ Протестировать все функции приложения
4. ✅ Запустить unit-тесты
5. ✅ Развернуть на реальном сервере

## Поддержка

Если возникли проблемы:
1. Проверьте `flutter doctor`
2. Убедитесь, что backend запущен
3. Проверьте логи в консоли
4. Посмотрите раздел "Возможные проблемы" выше

---

**Готово!** 🎉 Приложение должно работать. Удачного тестирования!
