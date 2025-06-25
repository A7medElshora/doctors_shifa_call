import 'package:doctors_shifa_call/features/home/data/models/work_hour/day.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/doctors_time_table.dart';

enum WorkHoursStatus { initial, loading, success, error }

class WorkHoursState {
  final WorkHoursStatus status;
  final List<Day> days;
  final DoctorTimeTable? timeTable;
  final String? errorMessage;

  WorkHoursState({
    this.status = WorkHoursStatus.initial,
    this.days = const [],
    this.timeTable,
    this.errorMessage,
  });

  WorkHoursState copyWith({
    WorkHoursStatus? status,
    List<Day>? days,
    DoctorTimeTable? timeTable,
    String? errorMessage,
  }) {
    return WorkHoursState(
      status: status ?? this.status,
      days: days ?? this.days,
      timeTable: timeTable ?? this.timeTable,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}