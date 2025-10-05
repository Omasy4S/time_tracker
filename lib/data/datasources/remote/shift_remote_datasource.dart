import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../models/shift_model.dart';

abstract class ShiftRemoteDataSource {
  Future<ShiftModel> startShift();
  Future<ShiftModel> finishShift({String? report});
  Future<List<ShiftModel>> getShifts();
}

class ShiftRemoteDataSourceImpl implements ShiftRemoteDataSource {
  final DioClient dioClient;

  ShiftRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ShiftModel> startShift() async {
    try {
      final response = await dioClient.dio.post(ApiConstants.shiftsStart);
      return ShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ShiftModel> finishShift({String? report}) async {
    try {
      final response = await dioClient.dio.patch(
        ApiConstants.shiftsFinish,
        data: {'report': report},
      );
      return ShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<ShiftModel>> getShifts() async {
    try {
      final response = await dioClient.dio.get(ApiConstants.shifts);
      final List<dynamic> data = response.data;
      return data.map((json) => ShiftModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final message = e.response?.data['error'] ?? 'Server error';
      return Exception(message);
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timeout');
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception('No internet connection');
    }
    return Exception('Something went wrong');
  }
}
