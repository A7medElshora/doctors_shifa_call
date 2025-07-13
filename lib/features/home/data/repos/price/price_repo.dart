import 'package:doctors_shifa_call/core/networking/api_error_handler.dart';
import 'package:doctors_shifa_call/core/networking/api_result.dart';
import 'package:doctors_shifa_call/core/networking/api_service.dart';
import 'package:doctors_shifa_call/features/home/data/models/price/price_model.dart';

class PriceRepo {
  final ApiService _apiService;

  PriceRepo(this._apiService);

  Future<ApiResult<PriceModel>> getDoctorPrices(String doctorId) async {
    try {
      final list = await _apiService.getDoctorPrices(doctorId);
      if (list.isEmpty) {
        return ApiResult.failure(ServerFailure("No prices found"));
      }
      return ApiResult.success(list.first);
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
  Future<ApiResult<void>> updateDoctorPrices(PriceModel priceModel) async {
    try {
      await _apiService.updateDoctorPrices(priceModel);
      return ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}
