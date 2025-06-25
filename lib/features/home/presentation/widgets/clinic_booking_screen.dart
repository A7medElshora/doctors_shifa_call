// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// // استيراد CustomAppBar و BottomNavBarWidget حسب مسار مشروعك:
// import 'package:doctors_shifa_call/core/utils/widgets/custom_app_bar_widget.dart';
// import 'package:doctors_shifa_call/core/utils/widgets/custom_nav_bar_widget.dart';

// // نموذج بيانات للحجز
// class Booking {
//   final String patientName;
//   final String visitType;
//   final DateTime dateTime;
//   final bool isOnline;
//   Booking({
//     required this.patientName,
//     required this.visitType,
//     required this.dateTime,
//     required this.isOnline,
//   });
// }

// class ClinicBookingScreen extends StatefulWidget {
//   const ClinicBookingScreen({super.key});

//   @override
//   State<ClinicBookingScreen> createState() => _ClinicBookingScreenState();
// }

// class _ClinicBookingScreenState extends State<ClinicBookingScreen> {
//   DateTime _selectedDate = DateTime.now();
//   String get _selectedDateString =>
//       DateFormat('MM/dd/yyyy').format(_selectedDate);

//   final List<Booking> _allBookings = [
//     Booking(
//         patientName: 'محمد علي',
//         visitType: 'استشارة',
//         dateTime: DateTime(2025, 6, 23, 9, 0),
//         isOnline: false),
//     Booking(
//         patientName: 'سعيد محمود',
//         visitType: 'متابعة',
//         dateTime: DateTime(2025, 6, 23, 10, 0),
//         isOnline: false),
//     Booking(
//         patientName: 'ليلى أحمد',
//         visitType: 'تشخيص',
//         dateTime: DateTime(2025, 6, 23, 11, 0),
//         isOnline: false),
//     Booking(
//         patientName: 'فاطمة عبدالله',
//         visitType: 'استشارة',
//         dateTime: DateTime(2025, 6, 23, 13, 0),
//         isOnline: false),
//     Booking(
//         patientName: 'خالد سعيد',
//         visitType: 'متابعة',
//         dateTime: DateTime(2025, 6, 23, 14, 0),
//         isOnline: false),
//     Booking(
//         patientName: 'نورا محمد',
//         visitType: 'تشخيص',
//         dateTime: DateTime(2025, 6, 23, 15, 0),
//         isOnline: false),
//     Booking(
//         patientName: 'علي حسن',
//         visitType: 'استشارة',
//         dateTime: DateTime(2025, 6, 23, 16, 30),
//         isOnline: true),
//   ];

//   List<Booking> get _bookingsForSelectedDate {
//     return _allBookings.where((b) {
//       return !b.isOnline &&
//           b.dateTime.year == _selectedDate.year &&
//           b.dateTime.month == _selectedDate.month &&
//           b.dateTime.day == _selectedDate.day;
//     }).toList()
//       ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
//   }

//   Future<void> _pickDate() async {
//     DateTime now = DateTime.now();
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(now.year - 1),
//       lastDate: DateTime(now.year + 1),
//       locale: const Locale('ar'),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Widget _buildHeaderCell(String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       alignment: Alignment.center,
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontSize: 16.sp,
//         ),
//       ),
//     );
//   }

//   Widget _buildDataCell(String text) {
//     return Container(
//       color: Colors.white, // خلفية بيضاء لكل خلية
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       alignment: Alignment.center,
//       child: Text(
//         text,
//         style: TextStyle(
//           color: Colors.black87,
//           fontSize: 14.sp,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     const Color backgroundMint = Color(0xFFA5E1CB);
//     const Color mainGreen = Color(0xFF00C4B4);
//     const Color whiteColor = Colors.white;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F8FD),
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60.h),
//         child: CustomAppBar(
//           title: 'جدول الحجوزات العيادة',
//           showBackInLeading: true,
//           showBackButton: true,
//           onBackPressed: () => Navigator.of(context).pop(),
//           showBell: false,
//           showUserIcon: false,
//           showGridInLeading: false,
//           backgroundColor: whiteColor,
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('اختر التاريخ',
//                   style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87)),
//               SizedBox(height: 8.h),
//               Row(
//                 children: [
//                   SizedBox(width: 37.w),
//                   GestureDetector(
//                     onTap: _pickDate,
//                     child: Container(
//                       height: 65.h,
//                       width: 330.w,
//                       padding: EdgeInsets.symmetric(horizontal: 12.w),
//                       decoration: BoxDecoration(
//                         color: whiteColor,
//                         borderRadius: BorderRadius.circular(24.r),
//                         border: Border.all(color: mainGreen, width: 1.5),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 4,
//                               offset: Offset(-3, 5))
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           SizedBox(width: 8.w),
//                           Expanded(
//                               child: Center(
//                                   child: Text(_selectedDateString,
//                                       style: TextStyle(
//                                           fontSize: 20.sp,
//                                           color: Colors.grey.shade600)))),
//                           Spacer(),
//                           Image.asset('assets/images/date_picker.png',
//                               width: 55.w, height: 55.w),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16.h),
//               Text('حجوزات اليوم:',
//                   style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87)),
//               SizedBox(height: 8.h),
//               Expanded(
//                 child: Container(
//                   // هذه القيود تجعل الحاوية تمتدّ لملء كل المساحة المتاحة
//                   constraints: BoxConstraints.expand(),
//                   padding:
//                       EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
//                   decoration: BoxDecoration(
//                     color: backgroundMint,
//                     borderRadius: BorderRadius.circular(24.r),
//                   ),
//                   child: _bookingsForSelectedDate.isEmpty
//                       ? Center(
//                           child: Text(
//                             'لا توجد حجوزات لهذا اليوم',
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         )
//                       : SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Table(
//                             border: TableBorder.all(color: mainGreen, width: 1),
//                             columnWidths: {
//                               0: FixedColumnWidth(150.w),
//                               1: FixedColumnWidth(80.w),
//                               2: FixedColumnWidth(60.w),
//                               3: FixedColumnWidth(100.w),
//                             },
//                             children: [
//                               // ترويسة الجدول
//                               TableRow(
//                                 decoration: BoxDecoration(
//                                   color: mainGreen,
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(24.r),
//                                     topRight: Radius.circular(24.r),
//                                   ),
//                                 ),
//                                 children: [
//                                   _buildHeaderCell('اسم المريض'),
//                                   _buildHeaderCell('نوع الزيارة'),
//                                   _buildHeaderCell('اليوم'),
//                                   _buildHeaderCell('التاريخ'),
//                                 ],
//                               ),
//                               // صفوف البيانات
//                               ..._bookingsForSelectedDate.map((b) {
//                                 final String dayStr =
//                                     DateFormat('EEEE', 'ar').format(b.dateTime);
//                                 final String dateStr =
//                                     DateFormat('d/M/yyyy').format(b.dateTime);
//                                 return TableRow(
//                                   children: [
//                                     _buildDataCell(b.patientName),
//                                     _buildDataCell(b.visitType),
//                                     _buildDataCell(dayStr),
//                                     _buildDataCell(dateStr),
//                                   ],
//                                 );
//                               }),
//                             ],
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: const BottomNavBarWidget(),
//     );
//   }
// }
