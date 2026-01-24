import 'dart:ui';
import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingOverlay extends StatelessWidget {
  final String message;
  final VoidCallback? onCancel;

  const LoadingOverlay({
    super.key,
    this.message = 'جاري التحميل...',
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (onCancel != null) {
          onCancel!();
        }
      },
      child: Stack(
        children: [
          // Blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Content
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Custom Loading Animation or Spinner
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 70.r,
                        height: 70.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.primaryColor),
                        ),
                      ),
                      Container(
                        width: 45.r,
                        height: 45.r,
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppColor.primaryColor,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    message,
                    style: AppStyle.font16_600Weight.copyWith(
                      color: const Color(0xFF1A3C34),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'يرجى الانتظار قليلاً',
                    style: AppStyle.font12_400Weight.copyWith(
                      color: const Color(0xFF8A9CA3),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
