import 'package:doctors_shifa_call/features/auth/data/models/login_response.dart';


class AuthState {
  final AuthStatus status;
  final LoginResponse? loginResponse;
  final String? errorMessage;

  AuthState({required this.status, this.loginResponse, this.errorMessage});
}

enum AuthStatus { initial, loading, success, failure }
