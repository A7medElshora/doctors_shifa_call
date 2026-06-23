import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:doctors_shifa_call/core/networking/api_result.dart';
import 'package:doctors_shifa_call/core/networking/api_service.dart';
import 'package:doctors_shifa_call/core/networking/api_error_handler.dart';
import 'package:doctors_shifa_call/features/auth/data/models/register_doctor_request.dart';
import 'package:doctors_shifa_call/features/auth/data/models/register_doctor_response.dart';
import 'package:doctors_shifa_call/features/auth/data/models/specialty_model.dart';
import 'package:doctors_shifa_call/features/auth/data/repos/registration_repo.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final ApiService _apiService;

  RegistrationRepositoryImpl(this._apiService);

  @override
  Future<ApiResult<List<SpecialtyModel>>> getSpecialties() async {
    try {
      debugPrint('Fetching specialties from API...');
      final specialties = await _apiService.getSpecialties();
      debugPrint(
          'Specialties fetched successfully: ${specialties.length} items');
      return ApiResult.success(specialties);
    } catch (e, stackTrace) {
      debugPrint('Error fetching specialties: $e');
      debugPrint('Stack trace: $stackTrace');
      if (e is DioException) {
        debugPrint('DioException response: ${e.response?.data}');
        return ApiResult.failure(ServerFailure.fromDioError(e));
      } else {
        return ApiResult.failure(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<ApiResult<RegisterDoctorResponse>> registerDoctor(
      RegisterDoctorRequest request,
      {CancelToken? cancelToken}) async {
    try {
      debugPrint('Registering doctor...');
      debugPrint('Request data: Name=${request.name}, Email=${request.email}');
      final response =
          await _apiService.registerDoctor(request, cancelToken: cancelToken);
      debugPrint(
          'Registration response: success=${response.success}, message=${response.message}');
      return ApiResult.success(response);
    } catch (e, stackTrace) {
      debugPrint('Error registering doctor: $e');
      debugPrint('Stack trace: $stackTrace');
      if (e is DioException) {
        debugPrint('DioException status: ${e.response?.statusCode}');
        debugPrint('DioException response data: ${e.response?.data}');

        // Try to parse the response if it exists
        final responseData = e.response?.data;
        if (responseData != null) {
          try {
            if (responseData is Map<String, dynamic>) {
              final extractedResponse = RegisterDoctorResponse(
                success:
                    responseData['Success'] ?? responseData['success'] ?? false,
                message: responseData['Message'] ??
                    responseData['message'] ??
                    'حدث خطأ',
                doctorId: responseData['DoctorId'] ?? responseData['doctorId'],
              );
              return ApiResult.success(extractedResponse);
            }
          } catch (_) {}
        }
        return ApiResult.failure(ServerFailure.fromDioError(e));
      } else {
        return ApiResult.failure(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<ApiResult<RegisterDoctorResponse>> updateDoctorProfile(
      RegisterDoctorRequest request,
      {CancelToken? cancelToken}) async {
    try {
      debugPrint('Updating doctor profile via real update endpoint...');
      debugPrint('Update payload: DoctorId=${request.doctorId}, '
          'Name=${request.name}, Mobile=${request.mobile}, '
          'BirthDate=${request.birthDate}, SpecialityId=${request.specialityId}');

      final response =
          await _apiService.updateDoctor(request, cancelToken: cancelToken);

      debugPrint(
          'Update response: success=${response.success}, message=${response.message}, doctorId=${response.doctorId}');
      return ApiResult.success(response);
    } catch (e, stackTrace) {
      debugPrint('Error updating doctor profile: $e');
      debugPrint('Stack trace: $stackTrace');
      if (e is DioException) {
        debugPrint('DioException status: ${e.response?.statusCode}');
        debugPrint('DioException response data: ${e.response?.data}');
        return ApiResult.failure(ServerFailure.fromDioError(e));
      }
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}
