import 'package:doctors_shifa_call/core/export.dart';
import 'package:doctors_shifa_call/features/app_status/presentation/screens/force_update_screen.dart';
import 'package:doctors_shifa_call/features/app_status/presentation/screens/maintenance_screen.dart';
import 'package:doctors_shifa_call/features/auth/presentation/screens/splash_screen/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/cubit/internet/internet_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final AppRouter appRouter;
  final RouteLogger routeLogger;

  const MyApp({
    super.key,
    required this.appRouter,
    required this.routeLogger,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ServicesLocator.introAppCubit.initApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildAppWithProviders(
      child: BlocListener<InternetCubit, InternetState>(
        listener: (context, state) {
          if (state is ConnectedState) {
            ServicesLocator.introAppCubit.initApp();
          }
          if (state is NotConnectedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  context.tr('no_internet'),
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<IntroAppCubit, IntroAppState>(
          bloc: ServicesLocator.introAppCubit,
          builder: (context, state) {
            if (state is IntroAppInitial) {
              return ScreenUtilInit(
                designSize: const Size(430, 932),
                minTextAdapt: true,
                splitScreenMode: true,
                child: MaterialApp(
                  navigatorKey: navigatorKey,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  navigatorObservers: [widget.routeLogger],
                  home: const Scaffold(
                    body: Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF00C4B4)),
                    ),
                  ),
                ),
              );
            }

            if (state is ForceUpdate) {
              return ScreenUtilInit(
                designSize: const Size(430, 932),
                minTextAdapt: true,
                splitScreenMode: true,
                child: MaterialApp(
                  navigatorKey: navigatorKey,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  navigatorObservers: [widget.routeLogger],
                  home: ForceUpdateScreen(appLink: state.appLink),
                ),
              );
            }

            if (state is AppUnderMaintenance) {
              return ScreenUtilInit(
                designSize: const Size(430, 932),
                minTextAdapt: true,
                splitScreenMode: true,
                child: MaterialApp(
                  navigatorKey: navigatorKey,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  navigatorObservers: [widget.routeLogger],
                  home: const MaintenanceScreen(),
                ),
              );
            }

            return ScreenUtilInit(
              designSize: const Size(430, 932),
              minTextAdapt: true,
              splitScreenMode: true,
              child: MaterialApp(
                navigatorKey: navigatorKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                navigatorObservers: [widget.routeLogger],
                title: 'Shifa Call Doctors App',
                theme: ThemeData(
                  scaffoldBackgroundColor: AppColor.backGroundColor,
                  textTheme: GoogleFonts.readexProTextTheme(),
                ),
                home: const SplashScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
