import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  static TextStyle font24_700Weight = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font20_600Weight = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font19_700Weight = TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font17_700Weight = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font18_600Weight = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font15_500Weight = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle font16_700Weight = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle font14_700Weight = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle font14_400Weight = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );
  static TextStyle font13_400Weight = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font12_600Weight = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle font11_400Weight = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle font10_400Weight = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
  );

  static InputBorder borderDone() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.secondaryColor),
      borderRadius: BorderRadius.circular(8),
    );
  }

  static InputBorder borderFocuse() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.secondaryColor),
      borderRadius: BorderRadius.circular(8),
    );
  }

  static InputBorder borderError(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
