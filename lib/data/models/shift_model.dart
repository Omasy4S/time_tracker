import '../../domain/entities/shift.dart';

class ShiftModel extends Shift {
  const ShiftModel({
    required super.id,
    required super.userId,
    required super.startTime,
    super.endTime,
    super.report,
    required super.status,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null 
          ? DateTime.parse(json['endTime'] as String) 
          : null,
      report: json['report'] as String?,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'report': report,
      'status': status,
    };
  }
}
