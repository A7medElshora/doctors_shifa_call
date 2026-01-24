import 'package:json_annotation/json_annotation.dart';

part 'doctor_profile.g.dart';

@JsonSerializable()
class DoctorProfile {
  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Email')
  final String email;

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

  @JsonKey(name: 'SpecialityDesc')
  final String? specialityDesc;

  @JsonKey(name: 'Photo')
  final String? photo;

  DoctorProfile({
    required this.name,
    required this.email,
    required this.mobile,
    required this.address,
    required this.birthDate,
    required this.university,
    required this.specialityId,
    this.specialityDesc,
    this.photo,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) =>
      _$DoctorProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorProfileToJson(this);

  // Create a copy with updated fields
  DoctorProfile copyWith({
    String? name,
    String? email,
    String? mobile,
    String? address,
    String? birthDate,
    String? university,
    int? specialityId,
    String? specialityDesc,
    String? photo,
  }) {
    return DoctorProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      university: university ?? this.university,
      specialityId: specialityId ?? this.specialityId,
      specialityDesc: specialityDesc ?? this.specialityDesc,
      photo: photo ?? this.photo,
    );
  }
}
