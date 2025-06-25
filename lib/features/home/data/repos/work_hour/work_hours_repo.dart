import 'package:doctors_shifa_call/core/networking/api_error_handler.dart';
import 'package:doctors_shifa_call/core/networking/api_result.dart';
import 'package:doctors_shifa_call/core/networking/api_service.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/day.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/doctors_time_table.dart';

class WorkHoursRepo {
  final ApiService _apiService;

  WorkHoursRepo(this._apiService);

  Future<ApiResult<List<Day>>> getDays() async {
    try {
      final days = await _apiService.getDays();
      return ApiResult.success(days);
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  Future<ApiResult<DoctorTimeTable>> getDoctorTimeTable(String doctorId, String dayNum) async {
    try {
      final timeTable = await _apiService.getDoctorTimeTable(doctorId, dayNum);
      return ApiResult.success(timeTable);
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  Future<ApiResult<void>> updateDoctorTimeTable(DoctorTimeTable timeTable) async {
    try {
      await _apiService.updateDoctorTimeTable(timeTable);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}