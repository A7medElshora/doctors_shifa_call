import 'package:doctors_shifa_call/features/home/data/repos/booking/termination_status_repo.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/booking/termination_status_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:doctors_shifa_call/core/utils/widgets/custom_app_bar_widget.dart';
import 'package:doctors_shifa_call/features/home/data/models/booking/booking.dart';
import 'package:doctors_shifa_call/features/video_call/export.dart';
import 'package:doctors_shifa_call/core/navigation/app_router.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/booking/online_bookings_cubit.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/booking/online_bookings_state.dart';
import 'package:doctors_shifa_call/features/home/presentation/cubits/booking/termination_status_cubit.dart';

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
    BlocProvider.of<OnlineBookingsCubit>(context)
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
    const Color mainGreen = Color(0xFF00C4B4);
    const Color white = Colors.white;

    return BlocProvider<TerminationStatusCubit>(
      create: (context) => TerminationStatusCubit(
        RepositoryProvider.of<TerminationStatusRepo>(context),
      )..fetchTerminationStatuses(),
      child: Scaffold(
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
                            color: white,
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
                            color: white,
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final formattedStartDate =
                          DateFormat('dd/M/yyyy').format(_startDate);
                      final formattedEndDate =
                          DateFormat('dd/M/yyyy').format(_endDate);
                      await BlocProvider.of<OnlineBookingsCubit>(context)
                          .refreshBookings(
                        widget.doctorId,
                        formattedStartDate,
                        formattedEndDate,
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: Color(0xffA5E1CB),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: BlocConsumer<OnlineBookingsCubit,
                          OnlineBookingsState>(
                        listener: (context, state) {
                          if (state.status == BookingsStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(state.errorMessage ??
                                      'حدث خطأ أثناء جلب الحجوزات، يرجى المحاولة لاحقًا')),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state.status == BookingsStatus.loading) {
                            return const Center(
                                child: CircularProgressIndicator());
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
                              final timeStr = DateFormat('hh:mm a', 'ar')
                                  .format(DateTime.parse(
                                      '2025-01-01 ${booking.time}'));
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: _BookingItem(
                                  patientName: booking.patientName,
                                  visitType: booking.visitType,
                                  dateStr: dateStr,
                                  timeStr: timeStr,
                                  onlineMeetingUrl:
                                      booking.onlineMeetingUrl ?? '',
                                  booking: booking,
                                  onStatusUpdate: () {
                                    final formattedStartDate =
                                        DateFormat('dd/M/yyyy')
                                            .format(_startDate);
                                    final formattedEndDate =
                                        DateFormat('dd/M/yyyy')
                                            .format(_endDate);
                                    BlocProvider.of<OnlineBookingsCubit>(
                                            context)
                                        .refreshBookings(
                                      widget.doctorId,
                                      formattedStartDate,
                                      formattedEndDate,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
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

class _BookingItem extends StatelessWidget {
  final String patientName;
  final String visitType;
  final String dateStr;
  final String timeStr;
  final String onlineMeetingUrl;
  final Booking booking;
  final VoidCallback onStatusUpdate;

  const _BookingItem({
    required this.patientName,
    required this.visitType,
    required this.dateStr,
    required this.timeStr,
    required this.onlineMeetingUrl,
    required this.booking,
    required this.onStatusUpdate,
  });

  DateTime _parseAppointmentTime(String dateStr, String timeStr) {
    // Parse date
    DateTime date = DateTime.parse(dateStr);
    int year = date.year;
    int month = date.month;
    int day = date.day;
    // Parse time (e.g., "16:45:60" -> handle seconds > 59 by setting to 0)
    List<String> timeParts = timeStr.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    int seconds = timeParts.length > 2 ? int.parse(timeParts[2]) : 0;
    if (seconds > 59) {
      seconds = 0; // Adjust invalid seconds
    }
    // Create local DateTime
    return DateTime(year, month, day, hours, minutes, seconds);
  }

  bool _isWithinCallWindow(DateTime appointmentTime) {
    DateTime now = DateTime.now();
    DateTime startWindow = appointmentTime.subtract(const Duration(minutes: 3));
    DateTime endWindow = appointmentTime.add(const Duration(minutes: 5));
    return now.isAfter(startWindow) && now.isBefore(endWindow);
  }

  void _navigateToVideoCall(BuildContext context) {
    // The user wants the room name to be auto-populated from the API.
    // The booking object contains the patientName which can be used as the channelName.
    // We will use a combination of patientName and reservationId to ensure uniqueness.
    final channelName = '${booking.reservationId}';
    final userId = booking.reservationId
        .toString(); // Using reservationId as a unique user ID

    if (booking.onlineMeetingUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('لا يمكن بدء المكالمة، بيانات الاجتماع غير متوفرة')),
      );
      return;
    }

    final appointmentTime = _parseAppointmentTime(booking.date, booking.time);
    if (!_isWithinCallWindow(appointmentTime)) {
      final formattedAppointment = '$dateStr الساعة $timeStr';
      final startWindow = appointmentTime.subtract(const Duration(minutes: 3));
      final endWindow = appointmentTime.add(const Duration(minutes: 5));
      final startTimeStr = DateFormat('hh:mm a', 'ar').format(startWindow);
      final endTimeStr = DateFormat('hh:mm a', 'ar').format(endWindow);
      final message =
          'الموعد هو $formattedAppointment ويمكنك الدخول من الساعة $startTimeStr إلى $endTimeStr';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 5),
        ),
      );
      return;
    }

    // Navigate to the VideoCallScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          channelName: channelName,
          userId: userId,
        ),
      ),
    );
  }

  void _showStatusDialog(BuildContext context) {
    if (booking.reservationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('معرف الحجز غير متوفر')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) =>
          BlocConsumer<TerminationStatusCubit, TerminationStatusState>(
        listener: (context, state) {
          if (state.status == TerminationStatusStateStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage ??
                      'حدث خطأ أثناء تحديث الحالة، يرجى المحاولة لاحقًا')),
            );
          } else if (state.status == TerminationStatusStateStatus.success) {
            onStatusUpdate();
          }
        },
        builder: (context, state) {
          if (state.status == TerminationStatusStateStatus.loading) {
            return const AlertDialog(
              content: Center(child: CircularProgressIndicator()),
            );
          }
          return AlertDialog(
            title: const Text('تحديث حالة الحجز'),
            content: DropdownButton<int>(
              isExpanded: true,
              value: booking.terminationStatusId,
              hint: const Text('اختر الحالة'),
              items: state.terminationStatuses.map((status) {
                return DropdownMenuItem<int>(
                  value: status.id,
                  child: Text(status.status),
                );
              }).toList(),
              onChanged: (value) async {
                if (value != null && value != booking.terminationStatusId) {
                  await context
                      .read<TerminationStatusCubit>()
                      .updateBookingStatus(
                        booking.reservationId!,
                        value,
                      );
                  Navigator.of(context).pop();
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatIsoDate(String display) {
    final parts = display.split('/');
    return '${parts[2].padLeft(4, '0')}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    const Color mainGreen = Color(0xFF00C4B4);
    const Color whiteColor = Colors.white;

    print('Booking termination status: ${booking.terminationStatus}');

    return GestureDetector(
      onTap: () => _showStatusDialog(context),
      child: Container(
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
                        'اسم المريض: ${patientName.isEmpty ? 'غير محدد' : patientName}',
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
                        'نوع الزيارة: ${visitType.isEmpty ? 'غير محدد' : visitType}',
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
                    onTap: () => _navigateToVideoCall(context),
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
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
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
                  'الحالة: ${booking.terminationStatus ?? 'غير محدد'}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
