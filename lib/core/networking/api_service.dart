import 'package:dio/dio.dart';
import 'package:doctors_shifa_call/features/home/data/models/booking/booking.dart';
import 'package:doctors_shifa_call/features/home/data/models/price/price_model.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/day.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/doctors_time_table.dart';
import 'package:retrofit/retrofit.dart';
import 'package:doctors_shifa_call/core/networking/api_constants.dart';
import 'package:doctors_shifa_call/features/auth/data/models/login_response.dart';
import 'package:doctors_shifa_call/features/auth/data/models/specialty_model.dart';
import 'package:doctors_shifa_call/features/auth/data/models/register_doctor_request.dart';
import 'package:doctors_shifa_call/features/auth/data/models/register_doctor_response.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.loginEndpoint)
  Future<LoginResponse> login(
    @Field("userName") String username,
    @Field("password") String password, {
    @CancelRequest() CancelToken? cancelToken,
  });

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

  @POST(ApiConstants.updateDoctorEndpoint)
  Future<RegisterDoctorResponse> updateDoctor(
    @Body() RegisterDoctorRequest request, {
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET('reservations/get_termination_status')
  Future<List<TerminationStatus>> getTerminationStatuses();

  @GET('reservations/update_status')
  Future<void> updateBookingStatus(
    @Query("reservation_id") int reservationId,
    @Query("Termination_status_id") int statusId,
  );

  // Registration endpoints
  @GET(ApiConstants.getSpecialtyDoctorEndpoint)
  Future<List<SpecialtyModel>> getSpecialties();

  @POST(ApiConstants.registerDoctorEndpoint)
  Future<RegisterDoctorResponse> registerDoctor(
    @Body() RegisterDoctorRequest request, {
    @CancelRequest() CancelToken? cancelToken,
  });
}
