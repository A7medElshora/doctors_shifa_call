import 'package:doctors_shifa_call/core/cubit/internet/internet_cubit.dart';
import 'package:doctors_shifa_call/core/networking/api_service.dart';
import 'package:doctors_shifa_call/core/networking/dio_factory.dart';
import 'package:doctors_shifa_call/core/services/locator/get_it_locator.dart';
import 'package:doctors_shifa_call/features/home/data/repos/work_hour/work_hours_repo.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/work_hour/work_hours_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildAppWithProviders({required Widget child}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => InternetCubit()..checkStreamConnection(),
      ),
      BlocProvider(
        create: (_) => ServicesLocator.authCubit,
      ),
      BlocProvider(
        create: (_) => WorkHoursCubit(WorkHoursRepo(ApiService(DioFactory.getDio()))),
      ),
    ],
    child: child,
  );
}