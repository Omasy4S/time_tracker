import 'package:equatable/equatable.dart';

abstract class ShiftEvent extends Equatable {
  const ShiftEvent();

  @override
  List<Object?> get props => [];
}

class StartShiftEvent extends ShiftEvent {}

class FinishShiftEvent extends ShiftEvent {
  final String? report;

  const FinishShiftEvent({this.report});

  @override
  List<Object?> get props => [report];
}

class LoadShiftsEvent extends ShiftEvent {}
