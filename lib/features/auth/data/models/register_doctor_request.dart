import 'package:json_annotation/json_annotation.dart';

part 'register_doctor_request.g.dart';

@JsonSerializable()
class RegisterDoctorRequest {
  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Email')
  final String email;

  @JsonKey(name: 'Password')
  final String password;

  @JsonKey(name: 'Mobile')
  final String mobile;

  @JsonKey(name: 'Address')
  final String address;

  @JsonKey(name: 'BirthDate')
  final String birthDate;

  @JsonKey(name: 'University')
  final String university;

  @JsonKey(name: 'SpecialityId')
  final int specialityId;

  @JsonKey(name: 'Photo')
  final String photo;

  @JsonKey(name: 'NationalIdPhotoFront')
  final String nationalIdPhotoFront;

  @JsonKey(name: 'NationalIdPhotoBack')
  final String nationalIdPhotoBack;

  @JsonKey(name: 'MembershipCard')
  final String membershipCard;

  @JsonKey(name: 'AdditionalPhotos')
  final List<AdditionalPhoto> additionalPhotos;

  RegisterDoctorRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.mobile,
    required this.address,
    required this.birthDate,
    required this.university,
    required this.specialityId,
    required this.photo,
    required this.nationalIdPhotoFront,
    required this.nationalIdPhotoBack,
    required this.membershipCard,
    required this.additionalPhotos,
  });

  factory RegisterDoctorRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterDoctorRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterDoctorRequestToJson(this);
}

@JsonSerializable()
class AdditionalPhoto {
  @JsonKey(name: 'PhotoType')
  final String photoType;

  @JsonKey(name: 'PhotoBase64')
  final String photoBase64;

  @JsonKey(name: 'FileName')
  final String fileName;

  AdditionalPhoto({
    required this.photoType,
    required this.photoBase64,
    required this.fileName,
  });

  factory AdditionalPhoto.fromJson(Map<String, dynamic> json) =>
      _$AdditionalPhotoFromJson(json);
  Map<String, dynamic> toJson() => _$AdditionalPhotoToJson(this);
}
