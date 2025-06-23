import 'package:doctors_shifa_call/core/cubit/internet/internet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildAppWithProviders({required Widget child}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => InternetCubit()..checkStreamConnection(),
      ),
    ],
    child: child,
  );
}
