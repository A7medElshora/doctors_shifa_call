import 'package:doctors_shifa_call/core/networking/api_error_handler.dart';
import 'package:doctors_shifa_call/core/networking/api_result.dart';
import 'package:doctors_shifa_call/core/networking/api_service.dart';
import 'package:doctors_shifa_call/features/home/data/models/booking/booking.dart';

class TerminationStatusRepo {
  final ApiService _apiService;

  TerminationStatusRepo(this._apiService);

  Future<ApiResult<List<TerminationStatus>>> getTerminationStatuses() async {
    try {
      final statuses = await _apiService.getTerminationStatuses();
      return ApiResult.success(statuses);
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  Future<ApiResult<void>> updateBookingStatus(int reservationId, int statusId) async {
    try {
      await _apiService.updateBookingStatus(reservationId, statusId);
      return ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}