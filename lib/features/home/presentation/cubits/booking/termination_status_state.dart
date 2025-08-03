import 'package:doctors_shifa_call/features/home/data/models/booking/booking.dart';

enum TerminationStatusStateStatus { initial, loading, success, error }

class TerminationStatusState {
  final TerminationStatusStateStatus status;
  final List<TerminationStatus> terminationStatuses;
  final String? errorMessage;

  TerminationStatusState({
    this.status = TerminationStatusStateStatus.initial,
    this.terminationStatuses = const [],
    this.errorMessage,
  });

  TerminationStatusState copyWith({
    TerminationStatusStateStatus? status,
    List<TerminationStatus>? terminationStatuses,
    String? errorMessage,
  }) {
    return TerminationStatusState(
      status: status ?? this.status,
      terminationStatuses: terminationStatuses ?? this.terminationStatuses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}