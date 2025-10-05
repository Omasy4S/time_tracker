# ⚡ Быстрый старт

## За 5 минут до запуска

### 1️⃣ Запустите Backend (1 минута)

```bash
cd backend
npm install
npm start
```

✅ Сервер запущен на `http://localhost:3000`

### 2️⃣ Запустите Flutter (2 минуты)

Откройте **новый терминал**:

```bash
cd ..
flutter pub get
flutter run
```

✅ Приложение запущено!

### 3️⃣ Протестируйте (2 минуты)

1. **Регистрация**: 
   - Email: `test@test.com`
   - Пароль: `123456`
   - Имя: `Тест`

2. **Начните смену** → Подождите → **Завершите смену**

3. **Посмотрите историю** 📊

---

## Возможные проблемы

### ❌ "Connection refused"

**Android эмулятор?** Измените в `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

### ❌ Backend не запускается

```bash
# Проверьте порт 3000
netstat -ano | findstr :3000

# Или измените порт в backend/.env
PORT=3001
```

---

## Команды

```bash
# Backend
cd backend && npm start

# Flutter
flutter run

# Тесты
flutter test

# Сборка APK
flutter build apk
```

---

**Готово!** 🎉 Теперь можно тестировать приложение.

Подробная инструкция: [SETUP.md](SETUP.md)
