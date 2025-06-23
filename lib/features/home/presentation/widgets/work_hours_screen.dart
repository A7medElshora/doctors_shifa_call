// work_hours_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// تأكد من مسار الاستيراد حسب مشروعك:
import 'package:doctors_shifa_call/core/utils/widgets/custom_app_bar_widget.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_nav_bar_widget.dart';

class WorkHoursScreen extends StatefulWidget {
  const WorkHoursScreen({Key? key}) : super(key: key);

  @override
  State<WorkHoursScreen> createState() => _WorkHoursScreenState();
}

class _WorkHoursScreenState extends State<WorkHoursScreen> {
  // قائمة أيام الأسبوع بالترتيب
  final List<String> _days = const [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];

  int _selectedDayIndex = 0;

  // قائمة ساعات العمل المتاحة: مثال عشوائي. استبدل بالقيم الحقيقية من الـ backend أو المنطق لديك.
  final List<String> _timeSlots = const [
    '12:10 م',
    '12:20 م',
    '12:30 م',
    '12:00 م',
    '03:00 م',
    '03:10 م',
    '02:50 م',
    '04:00 م',
    '01:30 م',
    '03:40 م',
    '05:00 م',
    // يمكنك إضافة أو إزالة أو جلب هذه القائمة ديناميكياً بحسب اليوم المختار.
  ];

  String? _selectedTime; // الوقت المختار

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FD), // لون خلفية خفيف
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: CustomAppBar(
            title: 'ساعات العمل',
            // نريد إظهار زر العودة في هذه الشاشة:
            showBackInLeading: true,
            showBackButton: true,
            onBackPressed: () {
              Navigator.of(context).pop();
            },
            // لا نحتاج أزرار أخرى في AppBar هنا، لكن إن أردت يمكن تفعيل showBell أو showGridInLeading بناءً على تصميمك:
            showBell: false,
            showUserIcon: false,
            showGridInLeading: false,
            backgroundColor: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // عنوان اختيار اليوم
                Text(
                  'اختر اليوم',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                // قائمة أيام الأسبوع أفقياً
                SizedBox(
                  height: 60.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _days.length,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    separatorBuilder: (context, index) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final day = _days[index];
                      final bool selected = index == _selectedDayIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDayIndex = index;
                            // عند تغيير اليوم، يمكنك هنا تهيئة _timeSlots بحسب اليوم
                            _selectedTime = null;
                            // مثلاً: جلب قائمة ساعات جديدة من الـ backend
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF00C4B4)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: selected
                                ? null
                                : Border.all(color: Colors.grey.shade300),
                            boxShadow: selected
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selected)
                                Icon(
                                  Icons.check_circle,
                                  size: 16.sp,
                                  color: Colors.white,
                                ),
                              if (!selected)
                                SizedBox(height: 16.sp + 4.h),
                              Text(
                                day,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: selected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 24.h),
                // عنوان اختيار الوقت
                Text(
                  'اختر ساعة العمل',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),

                // قائمة بالأوقات في GridView ليمكن التمرير عمودياً
                Expanded(
                  child: GridView.builder(
                    itemCount: _timeSlots.length,
                    padding: EdgeInsets.only(bottom: 16.h, top: 4.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      // childAspectRatio: العرض / الارتفاع. عدل هذه القيمة لتحكم بشكل المستطيلات.
                      childAspectRatio: 2.5,
                    ),
                    itemBuilder: (context, index) {
                      final time = _timeSlots[index];
                      final bool isSelected = _selectedTime == time;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTime = time;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF00C4B4)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: isSelected
                                ? null
                                : Border.all(color: Colors.grey.shade300),
                            boxShadow: isSelected
                                ? []
                                : [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                time,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              if (isSelected) ...[
                                SizedBox(width: 4.w),
                                Icon(
                                  Icons.check_circle,
                                  size: 16.sp,
                                  color: Colors.white,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBarWidget(),
        // إذا كنت تريد زر إضافة في هذه الصفحة أيضاً:
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   backgroundColor: const Color(0xFF00C4B4),
        //   child: const Icon(Icons.add),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
