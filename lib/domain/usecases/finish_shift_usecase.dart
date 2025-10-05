import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/shift.dart';
import '../repositories/shift_repository.dart';

class FinishShiftUseCase {
  final ShiftRepository repository;

  FinishShiftUseCase(this.repository);

  Future<Either<Failure, Shift>> call({String? report}) async {
    return await repository.finishShift(report: report);
  }
}
