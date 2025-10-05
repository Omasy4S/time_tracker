import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/shift_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/shift_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/shift_repository.dart';
import '../../domain/usecases/finish_shift_usecase.dart';
import '../../domain/usecases/get_shifts_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/start_shift_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/shift/shift_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        authRepository: sl(),
      ));

  sl.registerFactory(() => ShiftBloc(
        startShiftUseCase: sl(),
        finishShiftUseCase: sl(),
        getShiftsUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => StartShiftUseCase(sl()));
  sl.registerLazySingleton(() => FinishShiftUseCase(sl()));
  sl.registerLazySingleton(() => GetShiftsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      dioClient: sl(),
    ),
  );

  sl.registerLazySingleton<ShiftRepository>(
    () => ShiftRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ShiftRemoteDataSource>(
    () => ShiftRemoteDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton(() => DioClient());

  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
