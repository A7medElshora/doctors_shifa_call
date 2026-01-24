// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      success: json['Success'] as bool?,
      message: json['Message'] as String?,
      user: json['User'] == null
          ? null
          : UserData.fromJson(json['User'] as Map<String, dynamic>),
      doctor: json['Doctor'] == null
          ? null
          : DoctorData.fromJson(json['Doctor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'Success': instance.success,
      'Message': instance.message,
      'User': instance.user,
      'Doctor': instance.doctor,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      userId: (json['UserId'] as num).toInt(),
      userName: json['UserName'] as String,
      groupId: (json['GroupId'] as num).toInt(),
      groupName: json['GroupName'] as String?,
      doctorId: (json['DoctorId'] as num?)?.toInt(),
      patientId: (json['PatientId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'UserId': instance.userId,
      'UserName': instance.userName,
      'GroupId': instance.groupId,
      'GroupName': instance.groupName,
      'DoctorId': instance.doctorId,
      'PatientId': instance.patientId,
    };

DoctorData _$DoctorDataFromJson(Map<String, dynamic> json) => DoctorData(
      id: (json['Id'] as num).toInt(),
      name: json['Name'] as String,
      mobile: json['Mobile'] as String?,
      address: json['Address'] as String?,
      specialityId: (json['SpecialityId'] as num?)?.toInt(),
      specialityName: json['SpecialityName'] as String?,
      photo: json['Photo'] as String?,
      birthDate: json['BirthDate'] as String?,
      isActive: json['IsActive'] as bool?,
    );

Map<String, dynamic> _$DoctorDataToJson(DoctorData instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Mobile': instance.mobile,
      'Address': instance.address,
      'SpecialityId': instance.specialityId,
      'SpecialityName': instance.specialityName,
      'Photo': instance.photo,
      'BirthDate': instance.birthDate,
      'IsActive': instance.isActive,
    };
