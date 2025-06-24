import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doctors_shifa_call/core/utils/cache/cache_helper.dart';
import 'package:doctors_shifa_call/features/auth/presentation/screens/loginScreen/login_screen.dart';
import 'package:doctors_shifa_call/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _navigateNext() async {
    // انتظر مدة قصيرة حتى يظهر الـ Splash
    await Future.delayed(const Duration(seconds: 3));

    // تحقق من الاتصال بالإنترنت
    final connectivityResult = await Connectivity().checkConnectivity();
    final bool isOnline = connectivityResult != ConnectivityResult.none;

    // تحقق من حالة تسجيل الدخول
    final bool isLoggedIn = CacheHelper.getLoginStatus();

    if (isOnline && isLoggedIn) {
      // استرجع اسم المستخدم المسجل
      final String username = CacheHelper.getString(key: 'username') ?? '';
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(username: username),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(isOnline: isOnline),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Stack(
          children: [
            Container(
              width: 1.sw,
              height: 1.sh,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF68C3A2), Color(0xFF20BAC9)],
                ),
              ),
            ),
            // Top shadow overlay
            Positioned(
              top: 0,
              left: 0,
              right: 60.w,
              child: SvgPicture.asset(
                'assets/images/svgs/up_shadow.svg',
                width: 1.sw,
                height: 300.h,
                fit: BoxFit.fill,
              ),
            ),
            // Bottom shadow overlay
            Positioned(
              bottom: 0,
              left: 60.w,
              right: 0,
              child: SvgPicture.asset(
                'assets/images/svgs/down_shadow.svg',
                width: 1.sw,
                height: 300.h,
                fit: BoxFit.fill,
              ),
            ),
            // شعار التطبيق في الوسط
            Center(
              child: SvgPicture.asset(
                'assets/images/svgs/white_logo.svg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
