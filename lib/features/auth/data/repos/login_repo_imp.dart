import 'package:dio/dio.dart';
import 'package:doctors_shifa_call/core/networking/api_result.dart';
import 'package:doctors_shifa_call/core/networking/api_service.dart';
import 'package:doctors_shifa_call/core/networking/api_error_handler.dart';
import 'package:doctors_shifa_call/features/auth/data/models/login_response.dart';
import 'package:doctors_shifa_call/features/auth/data/repos/login_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<LoginResponse>> login(String username, String password) async {
    try {
      final responseList = await _apiService.login(username, password);
      if (responseList.isNotEmpty) {
        return ApiResult.success(responseList.first);
      } else {
        return ApiResult.failure(ServerFailure("Invalid credentials"));
      }
    } catch (e) {
      if (e is DioException) {
        return ApiResult.failure(ServerFailure.fromDioError(e));
      } else {
        return ApiResult.failure(ServerFailure(e.toString()));
      }
    }
  }
}
