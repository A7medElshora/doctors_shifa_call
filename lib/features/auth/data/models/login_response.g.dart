// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      userId: (json['user_id'] as num).toInt(),
      userName: json['user_name'] as String,
      groupId: (json['group_id'] as num).toInt(),
      pass: json['pass'] as String,
      doctorId: (json['doctor_id'] as num).toInt(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'group_id': instance.groupId,
      'pass': instance.pass,
      'doctor_id': instance.doctorId,
    };
