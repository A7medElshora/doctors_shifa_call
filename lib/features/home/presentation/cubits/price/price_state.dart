import 'package:doctors_shifa_call/features/home/data/models/price/price_model.dart';

enum PriceStatus { initial, loading, success, error }

class PriceState {
  final PriceStatus status;
  final PriceModel? priceModel;
  final String? errorMessage;

  PriceState({
    this.status = PriceStatus.initial,
    this.priceModel,
    this.errorMessage,
  });

  PriceState copyWith({
    PriceStatus? status,
    PriceModel? priceModel,
    String? errorMessage,
  }) {
    return PriceState(
      status: status ?? this.status,
      priceModel: priceModel ?? this.priceModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
