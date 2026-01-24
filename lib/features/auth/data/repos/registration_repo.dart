import 'package:dio/dio.dart';
import 'package:doctors_shifa_call/core/networking/api_result.dart';
import 'package:doctors_shifa_call/features/auth/data/models/register_doctor_request.dart';
import 'package:doctors_shifa_call/features/auth/data/models/register_doctor_response.dart';
import 'package:doctors_shifa_call/features/auth/data/models/specialty_model.dart';

abstract class RegistrationRepository {
  Future<ApiResult<List<SpecialtyModel>>> getSpecialties();
  Future<ApiResult<RegisterDoctorResponse>> registerDoctor(
      RegisterDoctorRequest request,
      {CancelToken? cancelToken});
}
