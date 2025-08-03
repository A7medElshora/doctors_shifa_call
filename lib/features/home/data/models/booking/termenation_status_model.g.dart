// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'termenation_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TerminationStatus _$TerminationStatusFromJson(Map<String, dynamic> json) =>
    TerminationStatus(
      id: (json['Id'] as num).toInt(),
      status: json['Termination_status'] as String,
    );

Map<String, dynamic> _$TerminationStatusToJson(TerminationStatus instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Termination_status': instance.status,
    };
