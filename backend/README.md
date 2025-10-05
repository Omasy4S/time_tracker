# Time Tracker Backend API

Express.js backend для приложения учета рабочего времени.

## Установка

```bash
npm install
```

## Запуск

### Production
```bash
npm start
```

### Development (с автоперезагрузкой)
```bash
npm run dev
```

Сервер запустится на `http://localhost:3000`

## Переменные окружения

Создайте файл `.env`:
```
PORT=3000
JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
```

## API Endpoints

### Health Check
```
GET /health
```

### Auth
```
POST /auth/register
POST /auth/login
```

### Shifts (требуется авторизация)
```
POST /shifts/start
PATCH /shifts/finish
GET /shifts
```

## Docker

```bash
docker build -t time-tracker-backend .
docker run -p 3000:3000 time-tracker-backend
```
