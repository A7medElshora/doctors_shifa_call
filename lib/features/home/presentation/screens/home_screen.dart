import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:doctors_shifa_call/features/home/presentation/screens/price/price_screen.dart';
import 'package:doctors_shifa_call/features/home/presentation/screens/settings/settings_screen.dart';
import 'package:doctors_shifa_call/features/home/presentation/widgets/bookings_screen.dart';
import 'package:doctors_shifa_call/features/home/presentation/widgets/work_hours_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final String fullName;
  final String doctorId;

  const HomeScreen({
    super.key,
    required this.username,
    required this.fullName,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(60.h),
        //   child: CustomAppBar(
        //     showBell: true,
        //     showUserIcon: true,
        //     showGridInLeading: false,
        //     showBackInLeading: false,
        //     showBackButton: false,
        //     onBackPressed: () {},
        //     onGridPressed: () {},
        //   ),
        // ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    children: [
                      const TextSpan(text: ' مرحبا بك , كيف حالك يا  '),
                      TextSpan(
                        text: fullName.isNotEmpty ? fullName : username,
                        style: TextStyle(color: AppColor.primaryColor),
                      ),
                      const TextSpan(text: ' ؟'),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/slider1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 0.9,
                    children: [
                      _HomeCard(
                        iconWidget: Image.asset(
                          'assets/images/svgs/work_hour.png',
                          width: 60.w,
                          height: 60.w,
                        ),
                        title: 'ساعات العمل',
                        subtitle: 'اختيار و معرفة المواعيد المتاحة',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WorkHoursScreen(doctorId: doctorId),
                            ),
                          );
                        },
                      ),
                      _HomeCard(
                        iconWidget: SvgPicture.asset(
                          'assets/images/svgs/on_clinic.svg',
                          width: 60.w,
                          height: 60.w,
                        ),
                        title: 'حجوزاتي',
                        subtitle: 'حجز مواعيدك في العيادة',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BookingsScreen(doctorId: doctorId),
                            ),
                          );
                        },
                      ),
                      _HomeCard(
                        iconWidget: Image.asset(
                          'assets/images/svgs/patient_file.png',
                          width: 60.w,
                          height: 60.w,
                        ),
                        title: 'السعر',
                        subtitle: 'تحديث أسعار الكشف',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PriceScreen(
                                doctorId: doctorId,
                              ),
                            ),
                          );
                        },
                      ),
                      _HomeCard(
                        iconWidget: Image.asset(
                          'assets/images/svgs/settings.png',
                          width: 60.w,
                          height: 60.w,
                        ),
                        title: 'الإعدادات',
                        subtitle: 'الاعدادات وتسجيل الخروج',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HomeCard({
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
              offset: Offset(0, 4),
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
