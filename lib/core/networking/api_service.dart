import 'package:dio/dio.dart';
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
}
