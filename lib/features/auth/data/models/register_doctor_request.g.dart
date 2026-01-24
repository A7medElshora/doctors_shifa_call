// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_doctor_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDoctorRequest _$RegisterDoctorRequestFromJson(
        Map<String, dynamic> json) =>
    RegisterDoctorRequest(
      name: json['Name'] as String,
      email: json['Email'] as String,
      password: json['Password'] as String,
      mobile: json['Mobile'] as String,
      address: json['Address'] as String,
      birthDate: json['BirthDate'] as String,
      university: json['University'] as String,
      specialityId: (json['SpecialityId'] as num).toInt(),
      photo: json['Photo'] as String,
      nationalIdPhotoFront: json['NationalIdPhotoFront'] as String,
      nationalIdPhotoBack: json['NationalIdPhotoBack'] as String,
      membershipCard: json['MembershipCard'] as String,
      additionalPhotos: (json['AdditionalPhotos'] as List<dynamic>)
          .map((e) => AdditionalPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RegisterDoctorRequestToJson(
        RegisterDoctorRequest instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Email': instance.email,
      'Password': instance.password,
      'Mobile': instance.mobile,
      'Address': instance.address,
      'BirthDate': instance.birthDate,
      'University': instance.university,
      'SpecialityId': instance.specialityId,
      'Photo': instance.photo,
      'NationalIdPhotoFront': instance.nationalIdPhotoFront,
      'NationalIdPhotoBack': instance.nationalIdPhotoBack,
      'MembershipCard': instance.membershipCard,
      'AdditionalPhotos': instance.additionalPhotos,
    };

AdditionalPhoto _$AdditionalPhotoFromJson(Map<String, dynamic> json) =>
    AdditionalPhoto(
      photoType: json['PhotoType'] as String,
      photoBase64: json['PhotoBase64'] as String,
      fileName: json['FileName'] as String,
    );

Map<String, dynamic> _$AdditionalPhotoToJson(AdditionalPhoto instance) =>
    <String, dynamic>{
      'PhotoType': instance.photoType,
      'PhotoBase64': instance.photoBase64,
      'FileName': instance.fileName,
    };
