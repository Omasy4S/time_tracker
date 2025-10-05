import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/shift.dart';
import '../repositories/shift_repository.dart';

class StartShiftUseCase {
  final ShiftRepository repository;

  StartShiftUseCase(this.repository);

  Future<Either<Failure, Shift>> call() async {
    return await repository.startShift();
  }
}
