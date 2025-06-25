import 'package:doctors_shifa_call/features/home/data/models/work_hour/day.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/doctors_time_table.dart';

enum WorkHoursStatus { initial, loading, success, error }
enum UpdateStatus { initial, loading, success, error }

class WorkHoursState {
  final WorkHoursStatus status;
  final UpdateStatus updateStatus;
  final List<Day> days;
  final DoctorTimeTable? timeTable;
  final String? errorMessage;
  final String? updateErrorMessage;

  WorkHoursState({
    this.status = WorkHoursStatus.initial,
    this.updateStatus = UpdateStatus.initial,
    this.days = const [],
    this.timeTable,
    this.errorMessage,
    this.updateErrorMessage,
  });

  WorkHoursState copyWith({
    WorkHoursStatus? status,
    UpdateStatus? updateStatus,
    List<Day>? days,
    DoctorTimeTable? timeTable,
    String? errorMessage,
    String? updateErrorMessage,
  }) {
    return WorkHoursState(
      status: status ?? this.status,
      updateStatus: updateStatus ?? this.updateStatus,
      days: days ?? this.days,
      timeTable: timeTable ?? this.timeTable,
      errorMessage: errorMessage ?? this.errorMessage,
      updateErrorMessage: updateErrorMessage ?? this.updateErrorMessage,
    );
  }
}