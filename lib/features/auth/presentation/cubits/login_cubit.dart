import 'package:doctors_shifa_call/core/utils/cache/cache_helper.dart';
import 'package:doctors_shifa_call/features/auth/data/models/login_response.dart';
import 'package:doctors_shifa_call/features/auth/data/repos/login_repo.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthState(status: AuthStatus.initial));

  Future<void> login(String username, String password) async {
    emit(AuthState(status: AuthStatus.loading));
    try {
      final result = await _authRepository.login(username, password);
      result.when(
        success: (loginResponse) async {
          print('Login successful: ${loginResponse.userName}');
          // تخزين userId كرمز مميز مع بيانات إضافية إذا لزم الأمر
          await CacheHelper.login(loginResponse.userId.toString());
          await CacheHelper.saveData(key: 'user_id', value: loginResponse.userId);
          await CacheHelper.saveData(key: 'username', value: loginResponse.userName);
          emit(AuthState(status: AuthStatus.success, loginResponse: loginResponse));
        },
        failure: (error) {
          print('Login failed: ${error.errMessages}');
          emit(AuthState(status: AuthStatus.failure, errorMessage: error.errMessages));
        },
      );
    } catch (e) {
      print('Login error: $e');
      emit(AuthState(status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> checkLoginStatus() async {
    bool isLoggedIn = CacheHelper.getLoginStatus();
    if (isLoggedIn) {
      String? token = await CacheHelper.getToken();
      if (token != null) {
        // استرجاع بيانات المستخدم إذا لزم الأمر
        int userId = CacheHelper.getInteger(key: 'user_id');
        String userName = CacheHelper.getString(key: 'username');
        emit(AuthState(
          status: AuthStatus.success,
          loginResponse: LoginResponse(
            userId: userId,
            userName: userName,
            groupId: 0,
            pass: '',
            doctorId: 0,
          ),
        ));
      } else {
        emit(AuthState(status: AuthStatus.failure, errorMessage: 'Token not found'));
      }
    } else {
      emit(AuthState(status: AuthStatus.initial));
    }
  }

  Future<void> logout() async {
    await CacheHelper.logout();
    await CacheHelper.removeData(key: 'user_id');
    await CacheHelper.removeData(key: 'username');
    emit(AuthState(status: AuthStatus.initial));
  }
}
