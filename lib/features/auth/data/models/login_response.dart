import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'Success')
  final bool? success;

  @JsonKey(name: 'Message')
  final String? message;

  @JsonKey(name: 'User')
  final UserData? user;

  @JsonKey(name: 'Doctor')
  final DoctorData? doctor;

  LoginResponse({
    this.success,
    this.message,
    this.user,
    this.doctor,
  });

  // Convenience getters for backwards compatibility with cubits
  int get userId => user?.userId ?? 0;
  String get userName => user?.userName ?? '';
  int get groupId => user?.groupId ?? 0;
  int get doctorId => user?.doctorId ?? 0;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class UserData {
  @JsonKey(name: 'UserId')
  final int userId;

  @JsonKey(name: 'UserName')
  final String userName;

  @JsonKey(name: 'GroupId')
  final int groupId;

  @JsonKey(name: 'GroupName')
  final String? groupName;

  @JsonKey(name: 'DoctorId')
  final int? doctorId;

  @JsonKey(name: 'PatientId')
  final int? patientId;

  UserData({
    required this.userId,
    required this.userName,
    required this.groupId,
    this.groupName,
    this.doctorId,
    this.patientId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class DoctorData {
  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Name')
  final String name;

  @JsonKey(name: 'Mobile')
  final String? mobile;

  @JsonKey(name: 'Address')
  final String? address;

  @JsonKey(name: 'SpecialityId')
  final int? specialityId;

  @JsonKey(name: 'SpecialityName')
  final String? specialityName;

  @JsonKey(name: 'Photo')
  final String? photo;

  @JsonKey(name: 'BirthDate')
  final String? birthDate;

  @JsonKey(name: 'IsActive')
  final bool? isActive;

  DoctorData({
    required this.id,
    required this.name,
    this.mobile,
    this.address,
    this.specialityId,
    this.specialityName,
    this.photo,
    this.birthDate,
    this.isActive,
  });

  factory DoctorData.fromJson(Map<String, dynamic> json) =>
      _$DoctorDataFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorDataToJson(this);
}
