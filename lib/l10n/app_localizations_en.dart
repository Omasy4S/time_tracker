// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Time Tracker';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get startTimer => 'Start Timer';

  @override
  String get stopTimer => 'Stop Timer';

  @override
  String get taskName => 'Task Name';

  @override
  String get description => 'Description';

  @override
  String get duration => 'Duration';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get totalTime => 'Total Time';

  @override
  String get activeTask => 'Active Task';

  @override
  String get recentTasks => 'Recent Tasks';

  @override
  String get noActiveTasks => 'No active tasks';

  @override
  String get hours => 'hours';

  @override
  String get minutes => 'minutes';

  @override
  String get hoursShort => 'h';

  @override
  String get minutesShort => 'm';
}
