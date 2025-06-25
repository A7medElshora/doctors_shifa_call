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

  Booking({
    required this.patientName,
    required this.time,
    required this.visitType,
    required this.date,
    required this.paymentDone,
    required this.doctorId,
    required this.onlineMeetingUrl,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);
}