import 'package:equatable/equatable.dart';
import '../../../domain/entities/shift.dart';

abstract class ShiftState extends Equatable {
  const ShiftState();

  @override
  List<Object?> get props => [];
}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftLoaded extends ShiftState {
  final List<Shift> shifts;
  final Shift? activeShift;

  const ShiftLoaded({
    required this.shifts,
    this.activeShift,
  });

  @override
  List<Object?> get props => [shifts, activeShift];
}

class ShiftError extends ShiftState {
  final String message;

  const ShiftError(this.message);

  @override
  List<Object> get props => [message];
}

class ShiftActionSuccess extends ShiftState {
  final String message;

  const ShiftActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}
