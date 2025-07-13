// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceModel _$PriceModelFromJson(Map<String, dynamic> json) => PriceModel(
      id: (json['id'] as num).toInt(),
      onlinePrice: (json['online_price'] as num).toDouble(),
      onlineUsdPrice: (json['online_usd_price'] as num).toDouble(),
    );

Map<String, dynamic> _$PriceModelToJson(PriceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'online_price': instance.onlinePrice,
      'online_usd_price': instance.onlineUsdPrice,
    };
