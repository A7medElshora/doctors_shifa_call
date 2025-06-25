import 'package:json_annotation/json_annotation.dart';
import 'time_slot.dart';

part 'doctors_time_table.g.dart';

@JsonSerializable()
class DoctorTimeTable {
  @JsonKey(name: 'doctor_id')
  final String doctorId;
  @JsonKey(name: 'day_number')
  final String dayNumber;
  final List<TimeSlot> daytimes;

  DoctorTimeTable({required this.doctorId, required this.dayNumber, required this.daytimes});

  factory DoctorTimeTable.fromJson(Map<String, dynamic> json) => _$DoctorTimeTableFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorTimeTableToJson(this);
}