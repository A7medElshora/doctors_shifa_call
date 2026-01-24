// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_doctor_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDoctorResponse _$RegisterDoctorResponseFromJson(
        Map<String, dynamic> json) =>
    RegisterDoctorResponse(
      success: json['Success'] as bool? ?? false,
      message: json['Message'] as String? ?? '',
      doctorId: (json['DoctorId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RegisterDoctorResponseToJson(
        RegisterDoctorResponse instance) =>
    <String, dynamic>{
      'Success': instance.success,
      'Message': instance.message,
      'DoctorId': instance.doctorId,
    };
