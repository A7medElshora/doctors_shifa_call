import 'package:json_annotation/json_annotation.dart';

part 'register_doctor_response.g.dart';

@JsonSerializable()
class RegisterDoctorResponse {
  @JsonKey(name: 'Success', defaultValue: false)
  final bool success;

  @JsonKey(name: 'Message', defaultValue: '')
  final String message;

  @JsonKey(name: 'DoctorId')
  final int? doctorId;

  RegisterDoctorResponse({
    required this.success,
    required this.message,
    this.doctorId,
  });

  factory RegisterDoctorResponse.fromJson(Map<String, dynamic> json) {
    // Handle different field name formats (case insensitive)
    bool successValue = false;
    if (json.containsKey('Success')) {
      successValue = json['Success'] == true || json['Success'] == 'true';
    } else if (json.containsKey('success')) {
      successValue = json['success'] == true || json['success'] == 'true';
    } else if (json.containsKey('IsSuccess')) {
      successValue = json['IsSuccess'] == true || json['IsSuccess'] == 'true';
    }

    String messageValue = '';
    if (json.containsKey('Message')) {
      messageValue = json['Message']?.toString() ?? '';
    } else if (json.containsKey('message')) {
      messageValue = json['message']?.toString() ?? '';
    } else if (json.containsKey('msg')) {
      messageValue = json['msg']?.toString() ?? '';
    }

    int? doctorIdValue;
    if (json.containsKey('DoctorId')) {
      doctorIdValue = json['DoctorId'] is int
          ? json['DoctorId']
          : int.tryParse(json['DoctorId']?.toString() ?? '');
    } else if (json.containsKey('doctorId')) {
      doctorIdValue = json['doctorId'] is int
          ? json['doctorId']
          : int.tryParse(json['doctorId']?.toString() ?? '');
    } else if (json.containsKey('doctor_id')) {
      doctorIdValue = json['doctor_id'] is int
          ? json['doctor_id']
          : int.tryParse(json['doctor_id']?.toString() ?? '');
    }

    return RegisterDoctorResponse(
      success: successValue,
      message: messageValue,
      doctorId: doctorIdValue,
    );
  }

  Map<String, dynamic> toJson() => _$RegisterDoctorResponseToJson(this);
}
