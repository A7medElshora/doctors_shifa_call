import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.build_circle_outlined,
                  size: 80.sp, color: const Color(0xFF00C4B4)),
              SizedBox(height: 24.h),
              Text(
                'التطبيق غير متاح حاليًا',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'نحن نقوم بعمل صيانة مؤقتة. يرجى المحاولة لاحقًا.',
                style: TextStyle(
                    fontSize: 15.sp, color: Colors.black87, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
