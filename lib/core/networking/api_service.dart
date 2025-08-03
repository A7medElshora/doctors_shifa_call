
import 'package:dio/dio.dart';
import 'package:doctors_shifa_call/features/home/data/models/booking/booking.dart';
import 'package:doctors_shifa_call/features/home/data/models/price/price_model.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/day.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/doctors_time_table.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/booking/termination_status_state.dart';
import 'package:doctors_shifa_call/features/home/presentation/widgets/clinic_booking_screen.dart';
import 'package:retrofit/retrofit.dart';
import 'package:doctors_shifa_call/core/networking/api_constants.dart';
import 'package:doctors_shifa_call/features/auth/data/models/login_response.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET(ApiConstants.loginEndpoint)
  Future<List<LoginResponse>> login(
    @Query("user_name") String username,
    @Query("pass") String password,
  );

  @GET(ApiConstants.getDaysEndpoint)
  Future<List<Day>> getDays();

  @GET(ApiConstants.getDoctorTimeTableEndpoint)
  Future<DoctorTimeTable> getDoctorTimeTable(
    @Query("doctor_id") String doctorId,
    @Query("day_num") String dayNum,
  );

  @POST(ApiConstants.updateDoctorTimeTableEndpoint)
  Future<void> updateDoctorTimeTable(
    @Body() DoctorTimeTable timeTable,
  );

  @GET(ApiConstants.getDoctorReservationsEndpoint)
  Future<List<Booking>> getDoctorReservations(
    @Query("doctor_id") String doctorId,
    @Query("date") String startDate,
    @Query("dateto") String endDate,
  );

  @GET(ApiConstants.getDoctorPricesEndpoint)
  Future<List<PriceModel>> getDoctorPrices(
    @Query("doctor_id") String doctorId,
  );

  @POST(ApiConstants.updateDoctorPricesEndpoint)
  Future<void> updateDoctorPrices(
    @Body() PriceModel priceModel,
  );

  @GET('reservations/get_termination_status')
  Future<List<TerminationStatus>> getTerminationStatuses();

  @GET('reservations/update_status')
  Future<void> updateBookingStatus(
    @Query("reservation_id") int reservationId,
    @Query("Termination_status_id") int statusId,
  );
}
