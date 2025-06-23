import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctors_shifa_call/core/export.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              'assets/images/svgs/logo.svg',
            ),
            verticalSpace(50),
            SvgPicture.asset(
              'assets/images/svgs/text_logo.svg',
            ),
            const Spacer(),
            Text(
              'All Rights Reserved © doctors_shifa_call 2024',
              style: AppStyle.font15_500Weight.copyWith(
                color: AppColor.whiteColor,
              ),
            ),
            verticalSpace(30),
          ],
        ),
      ),
    );
  }
}
