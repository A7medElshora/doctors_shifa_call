// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      timeName: json['time_name'] as String,
      timeId: json['time_id'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'time_name': instance.timeName,
      'time_id': instance.timeId,
      'active': instance.active,
    };
