// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Трекер Времени';

  @override
  String get login => 'Войти';

  @override
  String get logout => 'Выйти';

  @override
  String get email => 'Электронная почта';

  @override
  String get password => 'Пароль';

  @override
  String get startTimer => 'Запустить таймер';

  @override
  String get stopTimer => 'Остановить таймер';

  @override
  String get taskName => 'Название задачи';

  @override
  String get description => 'Описание';

  @override
  String get duration => 'Продолжительность';

  @override
  String get today => 'Сегодня';

  @override
  String get thisWeek => 'На этой неделе';

  @override
  String get thisMonth => 'В этом месяце';

  @override
  String get totalTime => 'Общее время';

  @override
  String get activeTask => 'Активная задача';

  @override
  String get recentTasks => 'Недавние задачи';

  @override
  String get noActiveTasks => 'Нет активных задач';

  @override
  String get hours => 'часов';

  @override
  String get minutes => 'минут';

  @override
  String get hoursShort => 'ч';

  @override
  String get minutesShort => 'м';
}
