import 'package:doctors_shifa_call/core/networking/api_error_handler.dart';
import 'package:doctors_shifa_call/core/networking/api_result.dart';
import 'package:doctors_shifa_call/core/networking/api_service.dart';
import 'package:doctors_shifa_call/features/home/data/models/booking/booking.dart';

class OnlineBookingsRepo {
  final ApiService _apiService;

  OnlineBookingsRepo(this._apiService);

  Future<ApiResult<List<Booking>>> getDoctorReservations(String doctorId, String startDate, String endDate) async {
    try {
      final bookings = await _apiService.getDoctorReservations(doctorId, startDate, endDate);
      return ApiResult.success(bookings);
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}