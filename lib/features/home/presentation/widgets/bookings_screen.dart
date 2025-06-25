import 'package:doctors_shifa_call/features/home/presentation/widgets/clinic_booking_screen.dart';
import 'package:doctors_shifa_call/features/home/presentation/widgets/online_bookings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_app_bar_widget.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_nav_bar_widget.dart';

class BookingsScreen extends StatelessWidget {
  final String doctorId; // إضافة doctorId كمعامل مطلوب

  const BookingsScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FD),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: CustomAppBar(
            title: 'جدول الحجوزات',
            showBackInLeading: true,
            showBackButton: true,
            onBackPressed: () {
              Navigator.of(context).pop();
            },
            showBell: false,
            showUserIcon: false,
            showGridInLeading: false,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 1.0,
              children: [
                _BookingCategoryCard(
                  iconWidget: SvgPicture.asset(
                    'assets/images/svgs/on_clinic.svg',
                    width: 60.w,
                    height: 60.w,
                  ),
                  title: 'العيادة',
                  subtitle: 'عرض الحجوزات في العيادة',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => const ClinicBookingScreen(),
                    //   ),
                    // );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('صفحة حجوزات العيادة لم تجهّز بعد')),
                    );
                  },
                ),
                _BookingCategoryCard(
                  iconWidget: SvgPicture.asset(
                    'assets/images/svgs/on_call.svg',
                    width: 60.w,
                    height: 60.w,
                  ),
                  title: 'أونلاين',
                  subtitle: 'عرض الحجوزات عبر الإنترنت',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OnlineBookingsScreen(doctorId: doctorId),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBarWidget(),
      ),
    );
  }
}

class _BookingCategoryCard extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _BookingCategoryCard({
    super.key,
    required this.iconWidget,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
