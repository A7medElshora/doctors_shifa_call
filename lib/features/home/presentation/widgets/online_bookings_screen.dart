import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';

// استيراد CustomAppBar و BottomNavBarWidget حسب مسار مشروعك:
import 'package:doctors_shifa_call/core/utils/widgets/custom_app_bar_widget.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_nav_bar_widget.dart';

// نموذج بيانات للحجز (يمكنك تغييره ليتناسب مع بياناتك من الbackend)
class Booking {
  final String patientName;
  final String visitType; // مثال: "استشارة" أو "علاج" أو غيره
  final DateTime dateTime; // تاريخ ووقت الحجز
  final bool isOnline; // true للأونلاين، false للعيادة
  Booking({
    required this.patientName,
    required this.visitType,
    required this.dateTime,
    required this.isOnline,
  });
}

class OnlineBookingsScreen extends StatefulWidget {
  const OnlineBookingsScreen({super.key});

  @override
  State<OnlineBookingsScreen> createState() => _OnlineBookingsScreenState();
}

class _OnlineBookingsScreenState extends State<OnlineBookingsScreen> {
  DateTime _selectedDate = DateTime.now();
  String get _selectedDateString =>
      DateFormat('MM/dd/yyyy').format(_selectedDate);

  // قائمة حجوزات وهمية للعرض. في تطبيق حقيقي جلب من الـ backend:
  final List<Booking> _allBookings = [
    Booking(
        patientName: 'محمد علي',
        visitType: 'استشارة',
        dateTime: DateTime(2025, 6, 23, 16, 30), // تاريخ 23/6/2025
        isOnline: true),
    Booking(
        patientName: 'سعيد محمود',
        visitType: 'متابعة',
        dateTime: DateTime(2025, 6, 23, 14, 00), // تاريخ 23/6/2025
        isOnline: true),
    Booking(
        patientName: 'ليلى أحمد',
        visitType: 'استشارة',
        dateTime: DateTime(2025, 6, 23, 11, 00), // تاريخ 23/6/2025
        isOnline: true),
    Booking(
        patientName: 'فاطمة عبدالله',
        visitType: 'استشارة',
        dateTime: DateTime(2025, 6, 23, 13, 00), // تاريخ 23/6/2025
        isOnline: true),
    Booking(
        patientName: 'خالد سعيد',
        visitType: 'متابعة',
        dateTime: DateTime(2025, 6, 23, 15, 00), // تاريخ 23/6/2025
        isOnline: true),
    Booking(
        patientName: 'نورا محمد',
        visitType: 'تشخيص',
        dateTime: DateTime(2025, 6, 23, 17, 00), // تاريخ 23/6/2025
        isOnline: true),
    Booking(
        patientName: 'علي حسن',
        visitType: 'تشخيص',
        dateTime: DateTime(2025, 4, 14, 10, 30),
        isOnline: false),
    // ... أضف المزيد حسب الحاجة
  ];

  // ترجع قائمة الحجوزات في اليوم المحدد للأونلاين
  List<Booking> get _bookingsForSelectedDate {
    return _allBookings.where((b) {
      return b.isOnline &&
          b.dateTime.year == _selectedDate.year &&
          b.dateTime.month == _selectedDate.month &&
          b.dateTime.day == _selectedDate.day;
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime)); // ترتيب حسب الوقت
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      locale: const Locale('ar'), // إن أردت واجهة عربية
      builder: (context, child) {
        // لجعل calendar rtl إن لزم:
        return child!;
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ألوان التصميم
    const Color backgroundMint = Color(0xFFD6F5EB); // خلفية خفيفة للأقسام
    const Color mainGreen = Color(0xFF00C4B4); // لون التحديد
    const Color whiteColor = Colors.white;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBar(
          title: 'جدول الحجوزات أونلاين',
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
              // اختيار التاريخ
              Text(
                'اختر التاريخ',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  SizedBox(width: 37.w),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      height: 65.h,
                      width: 330.w,
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
                      child: Row(
                        children: [
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Center(
                              child: Text(
                                _selectedDateString,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Image.asset(
                            'assets/images/date_picker.png',
                            width: 55.w,
                            height: 55.w,
                            // color: mainGreen, // لو الأيقونة أحادية اللون
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // عنوان الحجوزات لليوم
              Text(
                'حجوزات اليوم:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              // خلفية خضراء منحنية تحتوي على القائمة
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: Color(0xffA5E1CB),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: _bookingsForSelectedDate.isEmpty
                      ? Center(
                          child: Text(
                            'لا توجد حجوزات لهذا اليوم',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _bookingsForSelectedDate.length,
                          padding: EdgeInsets.only(bottom: 16.h),
                          itemBuilder: (context, index) {
                            final booking = _bookingsForSelectedDate[index];
                            // صيغة التاريخ والوقت للعرض:
                            final String dateStr =
                                DateFormat('d/M/yyyy').format(booking.dateTime);
                            final String timeStr = DateFormat('hh:mm a', 'ar')
                                .format(booking.dateTime);
                            // DateFormat hh:mm a يعطي مثل 04:30 م

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: _BookingItem(
                                patientName: booking.patientName,
                                visitType: booking.visitType,
                                dateStr: dateStr,
                                timeStr: timeStr,
                              ),
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

// ويدجت لعنصر الحجز المفرد
class _BookingItem extends StatelessWidget {
  final String patientName;
  final String visitType;
  final String dateStr; // مثال: "14/4/2025"
  final String timeStr; // مثال: "04:30 م"

  const _BookingItem({
    super.key,
    required this.patientName,
    required this.visitType,
    required this.dateStr,
    required this.timeStr,
  });

  @override
  Widget build(BuildContext context) {
    const Color mainGreen = Color(0xFF00C4B4);
    const Color whiteColor = Colors.white;

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
            // الصف العلوي: اسم المريض ونوع الزيارة
            Row(
              children: [
                // اسم المريض
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Color(0xffA5E1CB), // خلفية فاتحة قريب للون الأخضر
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
                // نوع الزيارة
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
            // الصف السفلي: أيقونة الفيديو + تاريخ ووقت
            Row(
              children: [
                SizedBox(width: 12.w),
                // حقل التاريخ
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
                // حقل الوقت
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
                        SizedBox(width: 4.w),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // أيقونة الفيديو (أونلاين)
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Color(0xffA5E1CB),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.videocam,
                      color: Color(0xFF00C4B4),
                      size: 28,
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
