import 'package:carousel_slider/carousel_slider.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_app_bar_widget.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_nav_bar_widget.dart';
import 'package:doctors_shifa_call/features/home/presentation/widgets/bookings_screen.dart';
import 'package:doctors_shifa_call/features/home/presentation/widgets/work_hours_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({
    super.key,
    required this.username, // pass the current user’s name, e.g. "Anas"
  });

  @override
  Widget build(BuildContext context) {
    // Ensure ScreenUtil is initialized in your app (e.g. in top-level widget).
    // Also ensure that the app’s locale/textDirection is set to RTL for Arabic.
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // Use your CustomAppBar:
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppBar(
            showBell: true,
            showUserIcon: true,
            showGridInLeading: false,
            showBackInLeading: false,
            showBackButton: false,
            onBackPressed: () {},
            onGridPressed: () {},
          ),
        ),

        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // Carousel/banner
                CarouselWidget(),
                SizedBox(height: 24.h),
                // Grid of 4 cards
                // We wrap in Expanded so it takes remaining space; if content might overflow, you can use SingleChildScrollView instead.
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 23.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio:
                        0.9, // adjust as needed to get roughly square cards
                    children: [
                      _HomeCard(
                        iconWidget: SvgPicture.asset(
                          'assets/images/svgs/work_hour.svg',
                          width: 60.w,
                          height: 60.w,
                        ),
                        title: 'ساعات العمل',
                        subtitle: 'اختيار و معرفة المواعيد المتاحة',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const WorkHoursScreen()),
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
                                builder: (_) => const BookingsScreen()),
                          );
                        },
                      ),
                      _HomeCard(
                        iconWidget: SvgPicture.asset(
                          'assets/images/svgs/file_patient.svg',
                          width: 60.w,
                          height: 60.w,
                        ),
                        title: 'المرضى',
                        subtitle: 'معرفة معلومات عن المرضى و مواعيد حجزهم',
                        onTap: () {
                          // Navigate to patients page
                        },
                      ),
                      _HomeCard(
                        iconWidget: SvgPicture.asset(
                          'assets/images/svgs/setting_icon.svg',
                          width: 60.w,
                          height: 60.w,
                        ),
                        title: 'الإعدادات',
                        subtitle: 'حجز مواعيدك في العيادة',
                        onTap: () {
                          // Navigate to settings
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom navigation bar
        bottomNavigationBar: const BottomNavBarWidget(),
      ),
    );
  }
}

/// A reusable card widget for each Home option.
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
        // Card styling similar to screenshot: white bg, rounded corners, slight shadow
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
            // Icon or image
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
// carousel_widget.dart

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final List<String> _placeholderImages = const [
    'assets/images/slider1.png',
    'assets/images/dr1.png',
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: _placeholderImages.map((image) {
            return Container(
              margin: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 150.h,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _placeholderImages.asMap().entries.map((entry) {
            return Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == entry.key
                    ? const Color(0xFF00C4B4)
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
