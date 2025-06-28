import 'dart:convert';
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/doctors_time_table.dart';
import 'package:doctors_shifa_call/features/home/data/models/work_hour/time_slot.dart';
import 'package:doctors_shifa_call/features/home/data/repos/work_hour/work_hours_repo.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/work_hour/work_hours_state.dart';

class WorkHoursCubit extends Cubit<WorkHoursState> {
  final WorkHoursRepo _repo;
  CancelableOperation? _currentOperation;

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
    // إلغاء أي عملية جلب سابقة
    await _currentOperation?.cancel();
    emit(state.copyWith(status: WorkHoursStatus.loading, timeTable: null));

    _currentOperation = CancelableOperation.fromFuture(
      _repo.getDoctorTimeTable(doctorId, dayNum),
    );

    final result = await _currentOperation!.valueOrCancellation();
    if (result == null) {
      // تم إلغاء العملية
      return;
    }

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
      String doctorId, Map<String, List<String>> selectedTimesByDay) async {
    emit(state.copyWith(updateStatus: UpdateStatus.loading, status: WorkHoursStatus.refresh));

    bool allSuccess = true;
    List<String> errorMessages = [];
    DoctorTimeTable? latestTimeTable;
    String? lastUpdatedDay;

    for (final dayNum in selectedTimesByDay.keys) {
      final currentTimeTableResult = await _repo.getDoctorTimeTable(doctorId, dayNum);
      await currentTimeTableResult.when(
        success: (currentTimeTable) async {
          final currentActiveTimeIds = currentTimeTable.daytimes
              .where((timeSlot) => timeSlot.active)
              .map((timeSlot) => timeSlot.timeId)
              .toSet();

          final selectedTimeIds = selectedTimesByDay[dayNum]!.toSet();

          final updatedActiveTimeIds = currentActiveTimeIds
              .difference(selectedTimeIds)
              .union(selectedTimeIds.difference(currentActiveTimeIds));

          final updatedDaytimes = currentTimeTable.daytimes.map((timeSlot) {
            return TimeSlot(
              timeName: timeSlot.timeName,
              timeId: timeSlot.timeId,
              active: updatedActiveTimeIds.contains(timeSlot.timeId),
            );
          }).toList();

          final updatedTimeTable = DoctorTimeTable(
            doctorId: doctorId,
            dayNumber: dayNum,
            daytimes: updatedDaytimes,
          );

          final jsonPayload = jsonEncode(updatedTimeTable.toJson());
          print('WorkHoursCubit: Sending JSON payload for day $dayNum: $jsonPayload');

          final result = await _repo.updateDoctorTimeTable(updatedTimeTable);
          await result.when(
            success: (_) async {
              print('WorkHoursCubit: Update successful for day $dayNum');
              final refreshResult = await _repo.getDoctorTimeTable(doctorId, dayNum);
              refreshResult.when(
                success: (newTimeTable) {
                  latestTimeTable = newTimeTable;
                  lastUpdatedDay = dayNum;
                },
                failure: (error) {
                  allSuccess = false;
                  errorMessages.add('فشل في تحديث الجدول ليوم $dayNum: ${error.errMessages}');
                },
              );
            },
            failure: (error) {
              allSuccess = false;
              errorMessages.add('فشل في تحديث الجدول ليوم $dayNum: ${error.errMessages}');
            },
          );
        },
        failure: (error) {
          allSuccess = false;
          errorMessages.add('فشل في جلب الجدول ليوم $dayNum: ${error.errMessages}');
        },
      );
    }

    if (allSuccess && latestTimeTable != null && lastUpdatedDay != null) {
      emit(state.copyWith(
        updateStatus: UpdateStatus.success,
        status: WorkHoursStatus.success,
        timeTable: latestTimeTable,
      ));
      await fetchTimeTable(doctorId, lastUpdatedDay! );
    } else {
      emit(state.copyWith(
        updateStatus: UpdateStatus.error,
        updateErrorMessage: errorMessages.join('\n'),
        status: WorkHoursStatus.error,
      ));
    }
  }

  @override
  Future<void> close() {
    _currentOperation?.cancel();
    return super.close();
  }
}