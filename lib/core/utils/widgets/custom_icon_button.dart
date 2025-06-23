import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.onPressed,
    required this.image,
    required this.title,
  });

  final void Function()? onPressed;
  final String image;
  final String title;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Column(
        children: [
          SvgPicture.asset(
            image,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            title,
            style: AppStyle.font13_400Weight.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
