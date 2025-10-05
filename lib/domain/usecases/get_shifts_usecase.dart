import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/shift.dart';
import '../repositories/shift_repository.dart';

class GetShiftsUseCase {
  final ShiftRepository repository;

  GetShiftsUseCase(this.repository);

  Future<Either<Failure, List<Shift>>> call() async {
    return await repository.getShifts();
  }
}
