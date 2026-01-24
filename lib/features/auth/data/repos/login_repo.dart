import 'package:dio/dio.dart';
import 'package:doctors_shifa_call/core/networking/api_result.dart';
import 'package:doctors_shifa_call/features/auth/data/models/login_response.dart';

abstract class AuthRepository {
  Future<ApiResult<LoginResponse>> login(String username, String password,
      {CancelToken? cancelToken});
}
