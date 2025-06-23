import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextButton extends StatelessWidget {
  final double width;
  final Color background;
  final bool isUpperCase;
  final double radius;
  final bool disable;
  final bool isBorder;
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final double? height;
  final TextStyle? customTextStyle;
  final double fontSize;
  final BorderRadiusGeometry customBorderRadius;
  final double elevation;
  final bool? activeIconImage;
  final String? iconImage;
  final Color? disableColor;
  const CustomTextButton({
    super.key,
    this.width = double.infinity,
    this.background = AppColor.primaryColor,
    this.isBorder = false,
    this.isUpperCase = true,
    this.radius = 4.0,
    required this.onPressed,
    required this.text,
    this.disable = false,
    this.isLoading = false,
    this.height = 42,
    this.customTextStyle,
    this.fontSize = 18.0,
    this.elevation = 1.0,
    this.customBorderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.activeIconImage = false,
    this.iconImage,
    this.disableColor = AppColor.subTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final textButton = SizedBox(
      height: height,
      width: width,
      child: TextButton(
        onPressed: disable ? null : onPressed,
        style: TextButton.styleFrom(
          elevation: elevation,
          backgroundColor: disable ? disableColor : background,
          shape: RoundedRectangleBorder(
            borderRadius: customBorderRadius,
            side: isBorder
                ? BorderSide(color: AppColor.primaryColor, width: 1.0.w)
                : BorderSide.none,
          ),
        ),
        child: FittedBox(
          child: Row(
            children: [
              if (activeIconImage!) ...[
                SvgPicture.asset(
                  iconImage!,
                  width: 25.w,
                  height: 25.h,
                ),
                SizedBox(width: 10.w),
              ],
              Text(
                isUpperCase ? text.toUpperCase() : text,
                style: customTextStyle ??
                    TextStyle(
                      color: disable
                          ? AppColor.subTitleColor
                          : AppColor.primaryColor,
                      fontSize: fontSize.sp,
                    ),
              ),
            ],
          ),
        ),
      ),
    );

    final TextButtonLoading = SizedBox(
      height: height,
      child: TextButton(
        onPressed: disable ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: disable ? disableColor : background,
          shape: RoundedRectangleBorder(
            borderRadius: customBorderRadius,
            side: isBorder
                ? const BorderSide(color: Colors.red, width: 2.0)
                : BorderSide.none,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );

    return isLoading
        ? SizedBox(
            height: 45,
            child: TextButtonLoading,
          )
        : SizedBox(
            width: width,
            height: height,
            child: textButton,
          );
  }
}
