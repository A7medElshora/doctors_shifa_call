import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking {
  @JsonKey(name: 'name')
  final String patientName;
  final String time;
  @JsonKey(name: 'visit_type')
  final String visitType;
  final String date;
  @JsonKey(name: 'payment_done')
  final bool paymentDone;
  @JsonKey(name: 'doctor_id')
  final int doctorId;
  @JsonKey(name: 'online_meeting_url')
  final String onlineMeetingUrl;
  @JsonKey(name: 'id')
  final int? reservationId;
  @JsonKey(name: 'Termination_status')
  final String terminationStatus;
  @JsonKey(name: 'Termination_status_id')
  final int? terminationStatusId;

  Booking({
    required this.patientName,
    required this.time,
    required this.visitType,
    required this.date,
    required this.paymentDone,
    required this.doctorId,
    required this.onlineMeetingUrl,
    this.reservationId,
    required this.terminationStatus,
    this.terminationStatusId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
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
