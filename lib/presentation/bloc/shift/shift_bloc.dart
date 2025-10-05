import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/shift.dart';
import '../../../domain/usecases/finish_shift_usecase.dart';
import '../../../domain/usecases/get_shifts_usecase.dart';
import '../../../domain/usecases/start_shift_usecase.dart';
import 'shift_event.dart';
import 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final StartShiftUseCase startShiftUseCase;
  final FinishShiftUseCase finishShiftUseCase;
  final GetShiftsUseCase getShiftsUseCase;

  ShiftBloc({
    required this.startShiftUseCase,
    required this.finishShiftUseCase,
    required this.getShiftsUseCase,
  }) : super(ShiftInitial()) {
    on<StartShiftEvent>(_onStartShift);
    on<FinishShiftEvent>(_onFinishShift);
    on<LoadShiftsEvent>(_onLoadShifts);
  }

  Future<void> _onStartShift(
    StartShiftEvent event,
    Emitter<ShiftState> emit,
  ) async {
    emit(ShiftLoading());

    final result = await startShiftUseCase();

    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (shift) {
        emit(const ShiftActionSuccess('Смена начата'));
        add(LoadShiftsEvent());
      },
    );
  }

  Future<void> _onFinishShift(
    FinishShiftEvent event,
    Emitter<ShiftState> emit,
  ) async {
    emit(ShiftLoading());

    final result = await finishShiftUseCase(report: event.report);

    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (shift) {
        emit(const ShiftActionSuccess('Смена завершена'));
        add(LoadShiftsEvent());
      },
    );
  }

  Future<void> _onLoadShifts(
    LoadShiftsEvent event,
    Emitter<ShiftState> emit,
  ) async {
    emit(ShiftLoading());

    final result = await getShiftsUseCase();

    result.fold(
      (failure) => emit(ShiftError(failure.message)),
      (shifts) {
        // Найти активную смену, если есть
        Shift? activeShift;
        try {
          activeShift = shifts.firstWhere((shift) => shift.isActive);
        } catch (e) {
          activeShift = null;
        }

        emit(ShiftLoaded(
          shifts: shifts,
          activeShift: activeShift,
        ));
      },
    );
  }
}
