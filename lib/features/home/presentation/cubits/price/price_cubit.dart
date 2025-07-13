import 'package:bloc/bloc.dart';
import 'package:doctors_shifa_call/features/home/data/models/price/price_model.dart';
import 'package:doctors_shifa_call/features/home/data/repos/price/price_repo.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/price/price_state.dart';

class PriceCubit extends Cubit<PriceState> {
  final PriceRepo _repo;

  PriceCubit(this._repo) : super(PriceState());

  Future<void> fetchPrices(String doctorId) async {
    emit(state.copyWith(status: PriceStatus.loading));
    final result = await _repo.getDoctorPrices(doctorId);
    result.when(
      success: (priceModel) {
        emit(state.copyWith(
          status: PriceStatus.success,
          priceModel: priceModel,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: PriceStatus.error,
          errorMessage: error.errMessages,
        ));
      },
    );
  }

  Future<void> updatePrices(PriceModel priceModel) async {
    emit(state.copyWith(status: PriceStatus.loading));
    final result = await _repo.updateDoctorPrices(priceModel);
    result.when(
      success: (_) {
        emit(state.copyWith(
          status: PriceStatus.success,
          priceModel: priceModel,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: PriceStatus.error,
          errorMessage: error.errMessages,
        ));
      },
    );
  }
}
