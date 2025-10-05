import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date, [String? locale]) {
    final formatter = DateFormat('dd MMM yyyy', locale ?? 'ru_RU');
    return formatter.format(date);
  }

  static String formatTime(DateTime time, [String? locale]) {
    final formatter = DateFormat('HH:mm', locale ?? 'ru_RU');
    return formatter.format(time);
  }

  static String formatDateTime(DateTime dateTime, [String? locale]) {
    final formatter = DateFormat('dd MMM yyyy, HH:mm', locale ?? 'ru_RU');
    return formatter.format(dateTime);
  }

  static String formatDuration(Duration duration, [String? locale]) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    final isRussian = locale == null || locale.startsWith('ru');
    final hoursUnit = isRussian ? 'ч' : 'h';
    final minutesUnit = isRussian ? 'м' : 'm';
    
    if (hours > 0) {
      return '$hours$hoursUnit $minutes$minutesUnit';
    }
    return '$minutes$minutesUnit';
  }

  static String formatDurationLong(Duration duration, [String? locale]) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    final isRussian = locale == null || locale.startsWith('ru');
    
    if (isRussian) {
      if (hours > 0) {
        final hoursText = _getRussianHoursText(hours);
        final minutesText = _getRussianMinutesText(minutes);
        return minutes > 0 ? '$hours $hoursText $minutes $minutesText' : '$hours $hoursText';
      }
      return '$minutes ${_getRussianMinutesText(minutes)}';
    } else {
      if (hours > 0) {
        final hoursText = hours == 1 ? 'hour' : 'hours';
        final minutesText = minutes == 1 ? 'minute' : 'minutes';
        return minutes > 0 ? '$hours $hoursText $minutes $minutesText' : '$hours $hoursText';
      }
      final minutesText = minutes == 1 ? 'minute' : 'minutes';
      return '$minutes $minutesText';
    }
  }

  static String _getRussianHoursText(int hours) {
    if (hours % 10 == 1 && hours % 100 != 11) {
      return 'час';
    } else if ([2, 3, 4].contains(hours % 10) && ![12, 13, 14].contains(hours % 100)) {
      return 'часа';
    } else {
      return 'часов';
    }
  }

  static String _getRussianMinutesText(int minutes) {
    if (minutes % 10 == 1 && minutes % 100 != 11) {
      return 'минута';
    } else if ([2, 3, 4].contains(minutes % 10) && ![12, 13, 14].contains(minutes % 100)) {
      return 'минуты';
    } else {
      return 'минут';
    }
  }

  static Duration calculateDuration(DateTime start, DateTime? end) {
    if (end == null) {
      return DateTime.now().difference(start);
    }
    return end.difference(start);
  }
}
