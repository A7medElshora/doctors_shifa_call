import 'package:json_annotation/json_annotation.dart';

part 'termenation_status_model.g.dart';

@JsonSerializable()
class TerminationStatus {
  @JsonKey(name: 'Id')
  final int id;

  @JsonKey(name: 'Termination_status')
  final String status;

  TerminationStatus({
    required this.id,
    required this.status,
  });

  factory TerminationStatus.fromJson(Map<String, dynamic> json) =>
      _$TerminationStatusFromJson(json);

  Map<String, dynamic> toJson() => _$TerminationStatusToJson(this);
}
