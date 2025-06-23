abstract class InternetState {}
enum InternetConnection { connected, none }
class InternetInitial extends InternetState {}

class ConnectedState extends InternetState {
   InternetConnection connection;

  ConnectedState({required this.connection});
}

class NotConnectedState extends InternetState {
  final InternetConnection connection;

  NotConnectedState({required this.connection});
}
