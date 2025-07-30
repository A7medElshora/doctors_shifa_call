import 'package:bloc/bloc.dart';
import 'package:doctors_shifa_call/features/home/data/models/booking/booking.dart';
import 'package:doctors_shifa_call/features/home/data/repos/booking/termination_status_repo.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/booking/termination_status_state.dart';


class TerminationStatusCubit extends Cubit<TerminationStatusState> {
  final TerminationStatusRepo _repo;

  TerminationStatusCubit(this._repo) : super(TerminationStatusState());

  Future<void> fetchTerminationStatuses() async {
    emit(state.copyWith(status: TerminationStatusStateStatus.loading));
    final result = await _repo.getTerminationStatuses();
    result.when(
      success: (statuses) {
        emit(state.copyWith(
          status: TerminationStatusStateStatus.success,
          terminationStatuses: statuses,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: TerminationStatusStateStatus.error,
          errorMessage: error.errMessages,
        ));
      },
    );
  }

  Future<void> updateBookingStatus(int reservationId, int statusId) async {
    emit(state.copyWith(status: TerminationStatusStateStatus.loading));
    final result = await _repo.updateBookingStatus(reservationId, statusId);
    result.when(
      success: (_) {
        emit(state.copyWith(status: TerminationStatusStateStatus.success));
      },
      failure: (error) {
        emit(state.copyWith(
          status: TerminationStatusStateStatus.error,
          errorMessage: error.errMessages,
        ));
      },
    );
  }
}