import 'package:equatable/equatable.dart';

class Shift extends Equatable {
  final int id;
  final int userId;
  final DateTime startTime;
  final DateTime? endTime;
  final String? report;
  final String status;

  const Shift({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.report,
    required this.status,
  });

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';

  Duration get duration {
    if (endTime == null) {
      return DateTime.now().difference(startTime);
    }
    return endTime!.difference(startTime);
  }

  @override
  List<Object?> get props => [id, userId, startTime, endTime, report, status];
}
