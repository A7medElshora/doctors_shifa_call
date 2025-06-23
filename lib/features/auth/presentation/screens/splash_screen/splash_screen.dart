import 'package:doctors_shifa_call/features/auth/presentation/screens/loginScreen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// Import your LoginScreen here
// import 'package:your_app/features/auth/presentation/screens/login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(
              isOnline: false), // Provide the required isOnline argument
        ),
      );
    });
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
