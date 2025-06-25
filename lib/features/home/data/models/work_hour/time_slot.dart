import 'package:json_annotation/json_annotation.dart';

part 'time_slot.g.dart';

@JsonSerializable()
class TimeSlot {
  @JsonKey(name: 'time_name')
  final String timeName;
  @JsonKey(name: 'time_id')
  final String timeId;
  final bool active;

  TimeSlot({required this.timeName, required this.timeId, required this.active});

  factory TimeSlot.fromJson(Map<String, dynamic> json) => _$TimeSlotFromJson(json);
  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
}