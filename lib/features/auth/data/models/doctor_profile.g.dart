// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorProfile _$DoctorProfileFromJson(Map<String, dynamic> json) =>
    DoctorProfile(
      name: json['Name'] as String,
      email: json['Email'] as String,
      mobile: json['Mobile'] as String,
      address: json['Address'] as String,
      birthDate: json['BirthDate'] as String,
      university: json['University'] as String,
      specialityId: (json['SpecialityId'] as num).toInt(),
      specialityDesc: json['SpecialityDesc'] as String?,
      photo: json['Photo'] as String?,
    );

Map<String, dynamic> _$DoctorProfileToJson(DoctorProfile instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Email': instance.email,
      'Mobile': instance.mobile,
      'Address': instance.address,
      'BirthDate': instance.birthDate,
      'University': instance.university,
      'SpecialityId': instance.specialityId,
      'SpecialityDesc': instance.specialityDesc,
      'Photo': instance.photo,
    };
