import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_app_bar_widget.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_nav_bar_widget.dart';
import 'package:doctors_shifa_call/features/home/data/models/booking/booking.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/booking/online_bookings_cubit.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/booking/online_bookings_state.dart';

class OnlineBookingsScreen extends StatefulWidget {
  final String doctorId;

  const OnlineBookingsScreen({super.key, required this.doctorId});

  @override
  State<OnlineBookingsScreen> createState() => _OnlineBookingsScreenState();
}

class _OnlineBookingsScreenState extends State<OnlineBookingsScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBookings();
    });
  }

  void _fetchBookings() {
    final formattedStartDate = DateFormat('dd/M/yyyy').format(_startDate);
    final formattedEndDate = DateFormat('dd/M/yyyy').format(_endDate);
    context
        .read<OnlineBookingsCubit>()
        .fetchBookings(widget.doctorId, formattedStartDate, formattedEndDate);
  }

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('ar'),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_startDate.isAfter(_endDate)) {
          _endDate = _startDate;
        }
        _fetchBookings();
      });
    }
  }

  Future<void> _pickEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
      locale: const Locale('ar'),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _fetchBookings();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundMint = Color(0xFFD6F5EB);
    const Color mainGreen = Color(0xFF00C4B4);
    const Color whiteColor = Colors.white;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(
          title: ' الحجز الأونلاين',
          showBackInLeading: true,
          showBackButton: true,
          onBackPressed: () {
            Navigator.of(context).pop();
          },
          showBell: false,
          showUserIcon: false,
          showGridInLeading: false,
          backgroundColor: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختر الفترة الزمنية',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickStartDate,
                      child: Container(
                        height: 65.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: mainGreen, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(-3, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'من: ${DateFormat('MM/dd/yyyy').format(_startDate)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickEndDate,
                      child: Container(
                        height: 65.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: mainGreen, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: const Offset(-3, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'إلى: ${DateFormat('MM/dd/yyyy').format(_endDate)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'حجوزات الفترة:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: Color(0xffA5E1CB),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: BlocConsumer<OnlineBookingsCubit, OnlineBookingsState>(
                    listener: (context, state) {
                      if (state.status == BookingsStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  state.errorMessage ?? 'فشل في جلب الحجوزات')),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.status == BookingsStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.bookings.isEmpty) {
                        return Center(
                          child: Text(
                            'لا توجد حجوزات لهذه الفترة',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: state.bookings.length,
                        padding: EdgeInsets.only(bottom: 16.h),
                        itemBuilder: (context, index) {
                          final booking = state.bookings[index];
                          final dateStr = DateFormat('d/M/yyyy')
                              .format(DateTime.parse(booking.date));
                          final timeStr = DateFormat('hh:mm a', 'ar').format(
                              DateTime.parse('2025-01-01 ${booking.time}'));
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            child: _BookingItem(
                              patientName: booking.patientName,
                              visitType: booking.visitType,
                              dateStr: dateStr,
                              timeStr: timeStr,
                              onlineMeetingUrl: booking.onlineMeetingUrl,
                              booking: booking,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}

class _BookingItem extends StatelessWidget {
  final String patientName;
  final String visitType;
  final String dateStr;
  final String timeStr;
  final String onlineMeetingUrl;
  final Booking booking;

  const _BookingItem({
    required this.patientName,
    required this.visitType,
    required this.dateStr,
    required this.timeStr,
    required this.onlineMeetingUrl,
    required this.booking,
  });

  Future<void> _launchMeetingUrl(BuildContext context) async {
    print('Attempting to launch Zoom URL: $onlineMeetingUrl');

    if (onlineMeetingUrl.isEmpty || !onlineMeetingUrl.startsWith('https://')) {
      print('Invalid Zoom URL: $onlineMeetingUrl');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رابط Zoom غير صالح')),
      );
      return;
    }

    final Uri url = Uri.parse(onlineMeetingUrl);

    try {
      if (await canLaunchUrl(url)) {
        bool launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        print('Launch in external application: $launched');

        if (!launched) {
          launched = await launchUrl(
            url,
            mode: LaunchMode.platformDefault,
          );
          print('Launch in platform default: $launched');
        }

        if (!launched) {
          print('Failed to launch URL in both modes: $onlineMeetingUrl');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('فشل فتح رابط Zoom')),
          );
        }
      } else {
        print('Cannot launch URL: $onlineMeetingUrl');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن فتح رابط الاجتماع')),
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء فتح رابط Zoom: $e')),
      );
    }
  }

  String _formatIsoDate(String display) {
    final parts = display.split('/');
    return '${parts[2].padLeft(4, '0')}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const Color mainGreen = Color(0xFF00C4B4);
    const Color whiteColor = Colors.white;

    final now = DateTime.now();
    final bookingDateTime =
        DateTime.parse('${_formatIsoDate(dateStr)} ${booking.time}');
    final allowedStart = bookingDateTime.subtract(const Duration(minutes: 1));
    final allowedEnd = bookingDateTime.add(const Duration(minutes: 1));
    final isEnabled = now.isAfter(allowedStart) && now.isBefore(allowedEnd);

    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Color(0xffA5E1CB),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'اسم المريض: $patientName',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Color(0xffA5E1CB),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'نوع الزيارة: $visitType',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Color(0xffA5E1CB),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'التاريخ: $dateStr',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Color(0xffA5E1CB),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'الوقت: $timeStr',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.check_circle,
                          size: 16.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: isEnabled ? () => _launchMeetingUrl(context) : null,
                  child: Opacity(
                    opacity: isEnabled ? 1.0 : 0.4,
                    child: Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/svgs/vid.png',
                          width: 70.w,
                          height: 70.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
