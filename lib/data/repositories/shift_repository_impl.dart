import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/shift.dart';
import '../../domain/repositories/shift_repository.dart';
import '../datasources/remote/shift_remote_datasource.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftRemoteDataSource remoteDataSource;

  ShiftRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Shift>> startShift() async {
    try {
      final shift = await remoteDataSource.startShift();
      return Right(shift);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, Shift>> finishShift({String? report}) async {
    try {
      final shift = await remoteDataSource.finishShift(report: report);
      return Right(shift);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<Shift>>> getShifts() async {
    try {
      final shifts = await remoteDataSource.getShifts();
      return Right(shifts);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
