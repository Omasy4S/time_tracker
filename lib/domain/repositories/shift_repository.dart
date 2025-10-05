import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/shift.dart';

abstract class ShiftRepository {
  Future<Either<Failure, Shift>> startShift();
  
  Future<Either<Failure, Shift>> finishShift({String? report});
  
  Future<Either<Failure, List<Shift>>> getShifts();
}
