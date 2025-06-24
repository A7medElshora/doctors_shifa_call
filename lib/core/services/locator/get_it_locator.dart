import 'package:dio/dio.dart';
import 'package:doctors_shifa_call/core/export.dart';
import 'package:doctors_shifa_call/features/auth/data/repos/login_repo.dart';
import 'package:doctors_shifa_call/features/auth/data/repos/login_repo_imp.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/login_cubit.dart';
import 'package:get_it/get_it.dart';

class ServicesLocator {
  static final GetIt locator = GetIt.instance;

  static void setup() {
    // Dio & ApiService
    final Dio dio = DioFactory.getDio();
    locator.registerLazySingleton<ApiService>(() => ApiService(dio));

    // intro app
    locator.registerLazySingleton<IntroAppCubit>(() => IntroAppCubit());

    // auth
    locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(locator<ApiService>()));
    locator.registerLazySingleton<AuthCubit>(() => AuthCubit(locator<AuthRepository>()));
  }

  static IntroAppCubit get introAppCubit => locator<IntroAppCubit>();
  static AuthCubit get authCubit => locator<AuthCubit>();
}