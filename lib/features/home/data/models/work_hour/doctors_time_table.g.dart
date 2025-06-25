// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctors_time_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorTimeTable _$DoctorTimeTableFromJson(Map<String, dynamic> json) =>
    DoctorTimeTable(
      doctorId: json['doctor_id'] as String,
      dayNumber: json['day_number'] as String,
      daytimes: (json['daytimes'] as List<dynamic>)
          .map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DoctorTimeTableToJson(DoctorTimeTable instance) =>
    <String, dynamic>{
      'doctor_id': instance.doctorId,
      'day_number': instance.dayNumber,
      'daytimes': instance.daytimes,
    };
