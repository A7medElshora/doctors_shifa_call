import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/doctors_time_table.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/time_slot.dart';
import 'package:doctors_shifa_call/features/home/data/repos/work_hour/work_hours_repo.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/work_hour/work_hours_state.dart';

class WorkHoursCubit extends Cubit<WorkHoursState> {
  final WorkHoursRepo _repo;

  WorkHoursCubit(this._repo) : super(WorkHoursState());

  Future<void> fetchDays() async {
    emit(state.copyWith(status: WorkHoursStatus.loading));
    final result = await _repo.getDays();
    result.when(
      success: (days) {
        emit(state.copyWith(status: WorkHoursStatus.success, days: days));
      },
      failure: (error) {
        emit(state.copyWith(
            status: WorkHoursStatus.error, errorMessage: error.errMessages));
      },
    );
  }

  Future<void> fetchTimeTable(String doctorId, String dayNum) async {
    emit(state.copyWith(status: WorkHoursStatus.loading));
    final result = await _repo.getDoctorTimeTable(doctorId, dayNum);
    result.when(
      success: (timeTable) {
        emit(state.copyWith(
            status: WorkHoursStatus.success, timeTable: timeTable));
      },
      failure: (error) {
        emit(state.copyWith(
            status: WorkHoursStatus.error, errorMessage: error.errMessages));
      },
    );
  }

  Future<void> updateTimeSlots(
      String doctorId, String dayNum, List<String> selectedTimeIds) async {
    if (state.timeTable == null) {
      emit(state.copyWith(
        updateStatus: UpdateStatus.error,
        updateErrorMessage: 'لا يوجد جدول زمني لتحديثه',
      ));
      return;
    }

    print(
        'WorkHoursCubit: Updating time slots for doctorId=$doctorId, dayNum=$dayNum, selectedTimeIds=$selectedTimeIds');

    emit(state.copyWith(updateStatus: UpdateStatus.loading));

    // Create updated daytimes based on selectedTimeIds
    final updatedDaytimes = state.timeTable!.daytimes.map((timeSlot) {
      return TimeSlot(
        timeName: timeSlot.timeName,
        timeId: timeSlot.timeId,
        active: selectedTimeIds.contains(timeSlot.timeId),
      );
    }).toList();

    // Construct updated DoctorTimeTable
    final updatedTimeTable = DoctorTimeTable(
      doctorId: doctorId,
      dayNumber: dayNum,
      daytimes: updatedDaytimes,
    );

    // Log the JSON payload
    final jsonPayload = jsonEncode(updatedTimeTable.toJson());
    print('WorkHoursCubit: Sending JSON payload: $jsonPayload');

    final result = await _repo.updateDoctorTimeTable(updatedTimeTable);
    result.when(
      success: (_) async {
        print('WorkHoursCubit: Update successful, refreshing timetable');
        // Refresh timetable after successful update
        final refreshResult = await _repo.getDoctorTimeTable(doctorId, dayNum);
        refreshResult.when(
          success: (newTimeTable) {
            emit(state.copyWith(
              updateStatus: UpdateStatus.success,
              status: WorkHoursStatus.success,
              timeTable: newTimeTable,
            ));
          },
          failure: (error) {
            emit(state.copyWith(
              updateStatus: UpdateStatus.error,
              updateErrorMessage: 'فشل في تحديث الجدول: ${error.errMessages}',
            ));
          },
        );
      },
      failure: (error) {
        emit(state.copyWith(
          updateStatus: UpdateStatus.error,
          updateErrorMessage: 'فشل في تحديث الجدول: ${error.errMessages}',
        ));
      },
    );
  }
}
