import 'package:doctors_shifa_call/features/home/data/models/booking/booking.dart';

enum BookingsStatus { initial, loading, success, error }

class OnlineBookingsState {
  final BookingsStatus status;
  final List<Booking> bookings;
  final String? errorMessage;

  OnlineBookingsState({
    this.status = BookingsStatus.initial,
    this.bookings = const [],
    this.errorMessage,
  });

  OnlineBookingsState copyWith({
    BookingsStatus? status,
    List<Booking>? bookings,
    String? errorMessage,
  }) {
    return OnlineBookingsState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}