import 'package:json_annotation/json_annotation.dart';

part 'price_model.g.dart';

@JsonSerializable()
class PriceModel {
  // نقرأ من JSON المفتاح 'id'
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'online_price')
  final double onlinePrice;

  @JsonKey(name: 'online_usd_price')
  final double onlineUsdPrice;

  PriceModel({
    required this.id,
    required this.onlinePrice,
    required this.onlineUsdPrice,
  });

  // يصنع كائن من JSON كهربائي من الـ GET
  factory PriceModel.fromJson(Map<String, dynamic> json) =>
      _$PriceModelFromJson(json);

  // دالة يدوية تتحكم بالـ keys عند الإرسال للـ POST
  Map<String, dynamic> toJson() {
    return {
      'doctor_id': id,
      'online_price': onlinePrice,
      'online_usd_price': onlineUsdPrice,
    };
  }
}
