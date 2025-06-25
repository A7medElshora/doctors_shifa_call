// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
      patientName: json['name'] as String,
      time: json['time'] as String,
      visitType: json['visit_type'] as String,
      date: json['date'] as String,
      paymentDone: json['payment_done'] as bool,
      doctorId: (json['doctor_id'] as num).toInt(),
      onlineMeetingUrl: json['online_meeting_url'] as String,
    );

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'name': instance.patientName,
      'time': instance.time,
      'visit_type': instance.visitType,
      'date': instance.date,
      'payment_done': instance.paymentDone,
      'doctor_id': instance.doctorId,
      'online_meeting_url': instance.onlineMeetingUrl,
    };
