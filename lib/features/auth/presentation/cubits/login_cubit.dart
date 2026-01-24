import 'package:doctors_shifa_call/core/utils/cache/cache_helper.dart';
import 'package:doctors_shifa_call/features/auth/data/models/login_response.dart';
import 'package:doctors_shifa_call/features/auth/data/repos/login_repo.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository)
      : super(AuthState(status: AuthStatus.initial));

  Future<void> login(String username, String password) async {
    emit(AuthState(status: AuthStatus.loading));
    try {
      final result = await _authRepository.login(username, password);
      result.when(
        success: (loginResponse) async {
          print(
              'Login successful: userName=${loginResponse.userName}, doctorId=${loginResponse.doctorId}');

          // Check if IsActive is false
          if (loginResponse.doctor?.isActive == false) {
            print('Doctor account is inactive (IsActive: false)');
            emit(AuthState(
              status: AuthStatus.inactive,
              loginResponse: loginResponse,
              errorMessage: 'حساب الطبيب غير مفعل',
            ));
            return;
          }

          if (loginResponse.doctorId == 0) {
            print('Warning: doctor_id is 0, which may be invalid');
            emit(AuthState(
              status: AuthStatus.failure,
              errorMessage: 'Invalid doctor ID received from server',
            ));
            return;
          }
          // Save userId, username, and doctor_id
          await CacheHelper.login(loginResponse.userId.toString());
          await CacheHelper.saveData(
              key: 'user_id', value: loginResponse.userId);
          await CacheHelper.saveData(
              key: 'username', value: loginResponse.userName);
          await CacheHelper.saveData(
              key: 'doctor_id', value: loginResponse.doctorId);

          // Save doctor specific info for settings screen
          if (loginResponse.doctor != null) {
            await CacheHelper.saveData(
                key: 'doctor_name', value: loginResponse.doctor!.name);
            await CacheHelper.saveData(
                key: 'doctor_mobile',
                value: loginResponse.doctor!.mobile ?? '');
            await CacheHelper.saveData(
                key: 'doctor_address',
                value: loginResponse.doctor!.address ?? '');
            await CacheHelper.saveData(
                key: 'doctor_speciality',
                value: loginResponse.doctor!.specialityName ?? '');
            await CacheHelper.saveData(
                key: 'doctor_birth_date',
                value: loginResponse.doctor!.birthDate ?? '');
            await CacheHelper.saveData(
                key: 'doctor_photo', value: loginResponse.doctor!.photo ?? '');
            await CacheHelper.saveData(
                key: 'doctor_is_active', value: loginResponse.doctor!.isActive ?? true);
          }

          emit(AuthState(
              status: AuthStatus.success, loginResponse: loginResponse));
        },
        failure: (error) {
          print('Login failed: ${error.errMessages}');
          emit(AuthState(
              status: AuthStatus.failure, errorMessage: error.errMessages));
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
        // Retrieve user data
        int userId = CacheHelper.getInteger(key: 'user_id');
        String userName = CacheHelper.getString(key: 'username');
        int doctorId = CacheHelper.getInteger(key: 'doctor_id');
        bool isActive = CacheHelper.getBoolean(key: 'doctor_is_active');
        print(
            'CheckLoginStatus: userId=$userId, userName=$userName, doctorId=$doctorId, isActive=$isActive');
        
        if (doctorId == 0) {
          print('Error: Retrieved doctor_id is 0, logging out');
          await logout();
          emit(AuthState(
              status: AuthStatus.failure, errorMessage: 'Invalid doctor ID'));
          return;
        }
        
        // Check if account is inactive
        if (!isActive) {
          print('CheckLoginStatus: Account is inactive');
          emit(AuthState(
              status: AuthStatus.inactive, 
              errorMessage: 'حساب الطبيب غير مفعل'));
          return;
        }
        
        emit(AuthState(
          status: AuthStatus.success,
          loginResponse: LoginResponse(
            success: true,
            user: UserData(
              userId: userId,
              userName: userName,
              groupId: 0,
              doctorId: doctorId,
            ),
          ),
        ));
      } else {
        print('CheckLoginStatus: Token not found');
        emit(AuthState(
            status: AuthStatus.failure, errorMessage: 'Token not found'));
      }
    } else {
      print('CheckLoginStatus: User not logged in');
      emit(AuthState(status: AuthStatus.initial));
    }
  }

  Future<void> logout() async {
    print('Logging out, clearing cache');
    await CacheHelper.logout();
    await CacheHelper.removeData(key: 'user_id');
    await CacheHelper.removeData(key: 'username');
    await CacheHelper.removeData(key: 'doctor_id');
    await CacheHelper.removeData(key: 'doctor_name');
    await CacheHelper.removeData(key: 'doctor_mobile');
    await CacheHelper.removeData(key: 'doctor_address');
    await CacheHelper.removeData(key: 'doctor_speciality');
    await CacheHelper.removeData(key: 'doctor_birth_date');
    await CacheHelper.removeData(key: 'doctor_photo');
    await CacheHelper.removeData(key: 'doctor_is_active');
    emit(AuthState(status: AuthStatus.initial));
  }
}
