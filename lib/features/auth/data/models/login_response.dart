import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'user_name')
  final String userName;

  @JsonKey(name: 'group_id')
  final int groupId;

  @JsonKey(name: 'pass')
  final String pass;

  @JsonKey(name: 'doctor_id')
  final int doctorId;

  LoginResponse({
    required this.userId,
    required this.userName,
    required this.groupId,
    required this.pass,
    required this.doctorId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
