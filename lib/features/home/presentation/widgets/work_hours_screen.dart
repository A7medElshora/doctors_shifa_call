import 'package:doctors_shifa_call/core/utils/cache/cache_helper.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/work_hour/work_hours_cubit.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/work_hour/work_hours_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_app_bar_widget.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_nav_bar_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkHoursScreen extends StatefulWidget {
  final String doctorId;

  const WorkHoursScreen({super.key, required this.doctorId});

  @override
  State<WorkHoursScreen> createState() => _WorkHoursScreenState();
}

class _WorkHoursScreenState extends State<WorkHoursScreen> {
  String? _selectedDayNumber;
  final Set<String> _selectedTimes = {};
  late String _effectiveDoctorId;

  @override
  void initState() {
    super.initState();
    // Validate doctorId and fallback to CacheHelper
    _effectiveDoctorId = widget.doctorId;
    print('WorkHoursScreen: Initial doctorId=${widget.doctorId}');
    if (_effectiveDoctorId == '0' || _effectiveDoctorId.isEmpty) {
      final cachedDoctorId =
          CacheHelper.getInteger(key: 'doctor_id').toString();
      print(
          'WorkHoursScreen: Invalid doctorId, using cachedDoctorId=$cachedDoctorId');
      if (cachedDoctorId == '0' || cachedDoctorId.isEmpty) {
        print(
            'WorkHoursScreen: No valid doctorId found, redirecting to LoginScreen');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('معرف الطبيب غير صالح، يرجى تسجيل الدخول مرة أخرى')),
          );
          Navigator.pushReplacementNamed(context, 'loginScreen');
        });
      } else {
        _effectiveDoctorId = cachedDoctorId;
      }
    }
    context.read<WorkHoursCubit>().fetchDays();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FD),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: CustomAppBar(
            title: 'ساعات العمل',
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: BlocBuilder<WorkHoursCubit, WorkHoursState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'اختر اليوم',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 90.h,
                      child: Skeletonizer(
                        enabled: state.status == WorkHoursStatus.loading,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.status == WorkHoursStatus.loading
                              ? 7
                              : state.days.length,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 8.w),
                          itemBuilder: (context, index) {
                            if (state.status == WorkHoursStatus.loading) {
                              return Container(
                                width: 80.w,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 16.sp + 4.h),
                                    Container(
                                      width: 40.w,
                                      height: 14.h,
                                      color: Colors.grey.shade300,
                                    ),
                                  ],
                                ),
                              );
                            }
                            final day = state.days[index];
                            final bool selected =
                                day.number == _selectedDayNumber;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDayNumber = day.number;
                                  _selectedTimes.clear();
                                  print(
                                      'WorkHoursScreen: Fetching timetable for doctorId=$_effectiveDoctorId, dayNum=${day.number}');
                                  context.read<WorkHoursCubit>().fetchTimeTable(
                                      _effectiveDoctorId, day.number);
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
                                          ),
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
                                      day.name,
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
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'اختر ساعة العمل',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: state.status == WorkHoursStatus.error
                          ? Center(child: Text(state.errorMessage ?? 'حدث خطأ'))
                          : _selectedDayNumber == null
                              ? const Center(
                                  child: Text('اختر يوماً لعرض الأوقات'))
                              : Skeletonizer(
                                  enabled:
                                      state.status == WorkHoursStatus.loading &&
                                          state.timeTable == null,
                                  child: state.timeTable != null
                                      ? GridView.builder(
                                          itemCount:
                                              state.timeTable!.daytimes.length,
                                          padding: EdgeInsets.only(
                                              bottom: 16.h, top: 4.h),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 12.h,
                                            crossAxisSpacing: 12.w,
                                            childAspectRatio: 2.5,
                                          ),
                                          itemBuilder: (context, index) {
                                            final timeSlot = state
                                                .timeTable!.daytimes[index];
                                            final bool isSelected =
                                                _selectedTimes
                                                    .contains(timeSlot.timeId);
                                            final bool isActive =
                                                timeSlot.active;
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (isSelected) {
                                                    _selectedTimes.remove(
                                                        timeSlot.timeId);
                                                  } else {
                                                    _selectedTimes
                                                        .add(timeSlot.timeId);
                                                  }
                                                  print(
                                                      'WorkHoursScreen: Toggled timeSlot ${timeSlot.timeName}, isSelected=$isSelected, isActive=$isActive');
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color(0xFF00C4B4)
                                                      : isActive
                                                          ? const Color(
                                                              0xFFE0F7FA)
                                                          : Colors
                                                              .grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r),
                                                  border: isSelected
                                                      ? Border.all(
                                                          color: const Color(
                                                              0xFF00C4B4),
                                                          width: 2)
                                                      : Border.all(
                                                          color: Colors
                                                              .grey.shade400),
                                                  boxShadow: isSelected
                                                      ? [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black26,
                                                            blurRadius: 4,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ]
                                                      : [],
                                                ),
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.w),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      timeSlot.timeName,
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: isSelected
                                                            ? Colors.white
                                                            : isActive
                                                                ? Colors.black87
                                                                : Colors.grey
                                                                    .shade600,
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
                                        )
                                      : GridView.builder(
                                          itemCount:
                                              9, // Placeholder count for skeleton
                                          padding: EdgeInsets.only(
                                              bottom: 16.h, top: 4.h),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 12.h,
                                            crossAxisSpacing: 12.w,
                                            childAspectRatio: 2.5,
                                          ),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade400),
                                              ),
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.w),
                                              child: Container(
                                                width: 60.w,
                                                height: 14.h,
                                                color: Colors.grey.shade300,
                                              ),
                                            );
                                          },
                                        ),
                                ),
                    ),
                    SizedBox(height: 16.h),
                    Center(
                      child: ElevatedButton(
                        onPressed: _selectedTimes.isNotEmpty &&
                                _selectedDayNumber != null
                            ? () {
                                // context.read<WorkHoursCubit>().updateTimeSlots(
                                //       _effectiveDoctorId,
                                //       _selectedDayNumber!,
                                //       _selectedTimes.toList(),
                                //     );
                                print(
                                    'WorkHoursScreen: Confirm button pressed, selectedTimes=$_selectedTimes');
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C4B4),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'تأكيد',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                );
              },
            ),
          ),
        ),
        // bottomNavigationBar: const BottomNavBarWidget(),
      ),
    );
  }
}
