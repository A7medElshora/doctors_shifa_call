import 'dart:async';
import 'package:doctors_shifa_call/core/utils/cache/cache_helper.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/work_hour/work_hours_cubit.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/work_hour/work_hours_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_app_bar_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkHoursScreen extends StatefulWidget {
  final String doctorId;

  const WorkHoursScreen({super.key, required this.doctorId});

  @override
  State<WorkHoursScreen> createState() => _WorkHoursScreenState();
}

class _WorkHoursScreenState extends State<WorkHoursScreen> {
  final Set<String> _selectedDayNumbers = {};
  final Map<String, Set<String>> _selectedTimesByDay = {};
  late String _effectiveDoctorId;
  String? _currentDisplayedDay;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
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

  void _toggleDaySelection(String dayNumber) {
    if (_currentDisplayedDay == dayNumber) return; // تجنب إعادة جلب نفس اليوم

    setState(() {
      _currentDisplayedDay = dayNumber;
    });

    // إلغاء أي طلب سابق وتطبيق تأخير بسيط (debounce)
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!_selectedTimesByDay.containsKey(dayNumber)) {
        _selectedTimesByDay[dayNumber] = {};
      }
      context
          .read<WorkHoursCubit>()
          .fetchTimeTable(_effectiveDoctorId, dayNumber);
      print('WorkHoursScreen: Fetching timetable for day $dayNumber');
    });
  }

  void _toggleTimeSelection(String dayNumber, String timeId) {
    setState(() {
      if (!_selectedTimesByDay.containsKey(dayNumber)) {
        _selectedTimesByDay[dayNumber] = {};
      }
      if (_selectedTimesByDay[dayNumber]!.contains(timeId)) {
        _selectedTimesByDay[dayNumber]!.remove(timeId);
        if (_selectedTimesByDay[dayNumber]!.isEmpty) {
          _selectedDayNumbers.remove(dayNumber);
          _selectedTimesByDay.remove(dayNumber);
          if (_currentDisplayedDay == dayNumber) {
            _currentDisplayedDay = _selectedDayNumbers.isNotEmpty
                ? _selectedDayNumbers.last
                : null;
          }
        }
      } else {
        _selectedTimesByDay[dayNumber]!.add(timeId);
        _selectedDayNumbers.add(dayNumber);
      }
      print(
          'WorkHoursScreen: Toggled time $timeId for day $dayNumber, selected=${_selectedTimesByDay[dayNumber]!.contains(timeId)}');
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
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
            child: BlocConsumer<WorkHoursCubit, WorkHoursState>(
              listenWhen: (previous, current) =>
                  previous.updateStatus != current.updateStatus &&
                  (current.updateStatus == UpdateStatus.success ||
                      current.updateStatus == UpdateStatus.error),
              listener: (context, state) {
                if (state.updateStatus == UpdateStatus.success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تحديث ساعات العمل بنجاح')),
                  );
                  setState(() {
                    _selectedDayNumbers.clear();
                    _selectedTimesByDay.clear();
                    _currentDisplayedDay = null;
                  });
                } else if (state.updateStatus == UpdateStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(state.updateErrorMessage ??
                            'فشل في تحديث ساعات العمل')),
                  );
                }
              },
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
                        enabled: state.status == WorkHoursStatus.loading &&
                            state.days.isEmpty,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.status == WorkHoursStatus.loading &&
                                  state.days.isEmpty
                              ? 7
                              : (state.days.isEmpty ? 1 : state.days.length),
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 8.w),
                          itemBuilder: (context, index) {
                            if (state.status == WorkHoursStatus.loading &&
                                state.days.isEmpty) {
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

                            if (state.days.isEmpty) {
                              return const Center(
                                  child: Text('لا توجد أيام متاحة'));
                            }

                            final day = state.days[index];
                            final bool selected =
                                _selectedDayNumbers.contains(day.number);
                            final bool isCurrent =
                                _currentDisplayedDay == day.number;
                            return GestureDetector(
                              onTap: () => _toggleDaySelection(day.number),
                              child: Container(
                                width: 80.w,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: selected || isCurrent
                                      ? const Color(0xFF00C4B4)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: selected || isCurrent
                                      ? null
                                      : Border.all(color: Colors.grey.shade300),
                                  boxShadow: selected || isCurrent
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
                                    SizedBox(height: 16.sp + 4.h),
                                    Text(
                                      day.name,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: selected || isCurrent
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: selected || isCurrent
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
                          : _currentDisplayedDay == null
                              ? const Center(
                                  child: Text('اختر يوماً لعرض الأوقات'))
                              : Skeletonizer(
                                  enabled: state.status ==
                                          WorkHoursStatus.loading ||
                                      state.status == WorkHoursStatus.refresh ||
                                      state.timeTable?.dayNumber !=
                                          _currentDisplayedDay,
                                  child: state.timeTable != null &&
                                          state.timeTable!.dayNumber ==
                                              _currentDisplayedDay
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
                                                _selectedTimesByDay[
                                                            _currentDisplayedDay]
                                                        ?.contains(
                                                            timeSlot.timeId) ??
                                                    false;
                                            final bool isActive =
                                                timeSlot.active;

                                            Color backgroundColor;
                                            Color textColor;

                                            if (isSelected) {
                                              if (isActive) {
                                                // مختار لإلغاء التفعيل
                                                backgroundColor =
                                                    Colors.red.shade300;
                                                textColor = Colors.white;
                                              } else {
                                                // مختار للتفعيل
                                                backgroundColor =
                                                    const Color(0xFF00C4B4);
                                                textColor = Colors.white;
                                              }
                                            } else {
                                              if (isActive) {
                                                // مفعل وغير مختار
                                                backgroundColor =
                                                    const Color(0xFFE0F7FA);
                                                textColor = Colors.black87;
                                              } else {
                                                // غير مفعل وغير مختار
                                                backgroundColor =
                                                    Colors.grey.shade300;
                                                textColor =
                                                    Colors.grey.shade600;
                                              }
                                            }

                                            return GestureDetector(
                                              onTap: () => _toggleTimeSelection(
                                                  _currentDisplayedDay!,
                                                  timeSlot.timeId),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade400),
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
                                                        color: textColor,
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
                                          itemCount: 9,
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
                      child: state.updateStatus == UpdateStatus.loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _selectedDayNumbers.isNotEmpty
                                  ? () {
                                      final selectedTimesByDay =
                                          _selectedTimesByDay.map((day,
                                                  times) =>
                                              MapEntry(day, times.toList()));
                                      context
                                          .read<WorkHoursCubit>()
                                          .updateTimeSlots(
                                            _effectiveDoctorId,
                                            selectedTimesByDay,
                                          );
                                      print(
                                          'WorkHoursScreen: Confirm button pressed, selectedTimesByDay=$selectedTimesByDay');
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
                                _selectedDayNumbers.length == 1
                                    ? 'تأكيد اليوم'
                                    : 'تأكيد عام',
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
      ),
    );
  }
}
