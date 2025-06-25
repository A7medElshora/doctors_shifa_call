import 'package:bloc/bloc.dart';
import 'package:doctors_shifa_call/core/networking/api_result.dart';
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
        emit(state.copyWith(status: WorkHoursStatus.error, errorMessage: error.errMessages));
      },
    );
  }

  Future<void> fetchTimeTable(String doctorId, String dayNum) async {
    emit(state.copyWith(status: WorkHoursStatus.loading));
    final result = await _repo.getDoctorTimeTable(doctorId, dayNum);
    result.when(
      success: (timeTable) {
        emit(state.copyWith(status: WorkHoursStatus.success, timeTable: timeTable));
      },
      failure: (error) {
        emit(state.copyWith(status: WorkHoursStatus.error, errorMessage: error.errMessages));
      },
    );
  }
}
