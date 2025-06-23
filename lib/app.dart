import 'package:doctors_shifa_call/core/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/cubit/internet/internet_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final RouteLogger routeLogger;

  const MyApp({
    super.key,
    required this.appRouter,
    required this.routeLogger,
  });

  @override
  Widget build(BuildContext context) {
    return buildAppWithProviders(
      child: BlocListener<InternetCubit, InternetState>(
        listener: (context, state) {
          if (state is ConnectedState) {
            ServicesLocator.introAppCubit.initApp();

            // TODO create widget for connected
          }
          if (state is NotConnectedState) {
            showToast(
              msg: 'الانترنت غير مستقر حاليا',
              state: ToastedStates.error,
              // context: context,
              // style: ToastificationStyle.flatColored,
            );
            // TODO create widget for not connected
          }
        },
        child: ScreenUtilInit(
          designSize: const Size(428, 926),
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              routeLogger,
            ],
            title: 'doctors_shifa_call App',
            theme: ThemeData(
              scaffoldBackgroundColor: AppColor.backGroundColor,
              textTheme: GoogleFonts.cairoTextTheme(),
            ),
            onGenerateRoute: appRouter.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
