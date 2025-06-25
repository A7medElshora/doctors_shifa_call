import 'package:bloc/bloc.dart';
import 'package:doctors_shifa_call/features/home/data/repos/booking/online_bookings_repo.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/booking/online_bookings_state.dart';

class OnlineBookingsCubit extends Cubit<OnlineBookingsState> {
  final OnlineBookingsRepo _repo;

  OnlineBookingsCubit(this._repo) : super(OnlineBookingsState());

  Future<void> fetchBookings(String doctorId, String date) async {
    emit(state.copyWith(status: BookingsStatus.loading));
    final result = await _repo.getDoctorReservations(doctorId, date);
    result.when(
      success: (bookings) {
        emit(state.copyWith(
          status: BookingsStatus.success,
          bookings: bookings,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: BookingsStatus.error,
          errorMessage: error.errMessages,
        ));
      },
    );
  }
}