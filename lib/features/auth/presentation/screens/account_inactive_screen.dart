import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_style.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/login_cubit.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/login_state.dart';
import 'package:doctors_shifa_call/features/home/presentation/screens/home_screen.dart';
import 'package:doctors_shifa_call/features/auth/presentation/screens/loginScreen/login_screen.dart';

class AccountInactiveScreen extends StatefulWidget {
  final String username;
  final String password;

  const AccountInactiveScreen({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  State<AccountInactiveScreen> createState() => _AccountInactiveScreenState();
}

class _AccountInactiveScreenState extends State<AccountInactiveScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isRefreshing = false;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      await context.read<AuthCubit>().login(widget.username, widget.password);
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success &&
              state.loginResponse?.doctor?.isActive == true) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomeScreen(
                  username: state.loginResponse!.userName,
                  fullName: state.loginResponse!.doctor?.name ?? '',
                  doctorId: state.loginResponse!.doctorId.toString(),
                ),
              ),
            );
          } else if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'حدث خطأ أثناء التحديث'),
                backgroundColor: AppColor.redButtonColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                margin: EdgeInsets.all(16.w),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // الخلفية المتدرجة في الأعلى
              Container(
                width: double.infinity,
                height: 280.h,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF68C3A2), Color(0xFF20BAC9)],
                  ),
                ),
              ),

              // المحتوى الرئيسي
              SafeArea(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _handleRefresh,
                  color: AppColor.primaryColor,
                  backgroundColor: Colors.white,
                  displacement: 40.h,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 40.h),

                          // العنوان في الأعلى
                          Text(
                            'شفا كــول',
                            style: AppStyle.font24_700Weight.copyWith(
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),

                          SizedBox(height: 40.h),

                          // البطاقة الرئيسية
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // أيقونة التحذير مع Animation
                                ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: Container(
                                    width: 100.w,
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColor.orangeWarningColor
                                              .withOpacity(0.2),
                                          AppColor.orangeLightColor,
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColor.orangeWarningColor
                                            .withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.hourglass_top_rounded,
                                      size: 50.sp,
                                      color: AppColor.orangeWarningColor,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 24.h),

                                // العنوان الرئيسي
                                Text(
                                  'حسابك قيد المراجعة',
                                  style: AppStyle.font20_600Weight.copyWith(
                                    color: AppColor.titleColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                SizedBox(height: 12.h),

                                // النص التوضيحي
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.orangeLightColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    'يتم مراجعة بياناتك حالياً من قبل فريق الإدارة.\nسيتم تفعيل حسابك في أقرب وقت.',
                                    style: AppStyle.font14_400Weight.copyWith(
                                      color: AppColor.secondaryTitleColor,
                                      height: 1.6,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                SizedBox(height: 32.h),

                                // خط فاصل
                                Container(
                                  height: 1,
                                  color: AppColor.borderContainerColor,
                                ),

                                SizedBox(height: 24.h),

                                // رسالة السحب للتحديث أو مؤشر التحميل
                                if (_isRefreshing)
                                  _buildLoadingIndicator()
                                else
                                  _buildRefreshHint(),

                                SizedBox(height: 32.h),

                                // زر العودة لتسجيل الدخول
                                _buildLogoutButton(),
                              ],
                            ),
                          ),

                          SizedBox(height: 30.h),

                          // معلومات التواصل
                          // _buildContactInfo(),

                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRefreshHint() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.touch_app_rounded,
            size: 28.sp,
            color: AppColor.primaryColor,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'اسحب للأسفل للتحقق من حالة التفعيل',
          style: AppStyle.font14_400Weight.copyWith(
            color: AppColor.hintColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 40.w,
          height: 40.h,
          child: CircularProgressIndicator(
            color: AppColor.primaryColor,
            strokeWidth: 3,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'جاري التحقق من حالة الحساب...',
          style: AppStyle.font14_600Weight.copyWith(
            color: AppColor.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: () async {
          await context.read<AuthCubit>().logout();
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const LoginScreen(isOnline: true),
              ),
              (route) => false,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColor.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(
              color: AppColor.primaryColor,
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              size: 20.sp,
              color: AppColor.primaryColor,
            ),
            SizedBox(width: 8.w),
            Text(
              'تسجيل الخروج',
              style: AppStyle.font16_600Weight.copyWith(
                color: AppColor.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildContactInfo() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20.w),
  //     padding: EdgeInsets.all(16.w),
  //     decoration: BoxDecoration(
  //       color: AppColor.containerColor,
  //       borderRadius: BorderRadius.circular(16.r),
  //       border: Border.all(
  //         color: AppColor.borderContainerColor,
  //         width: 1,
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(10.w),
  //           decoration: BoxDecoration(
  //             color: AppColor.primaryColor.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(10.r),
  //           ),
  //           child: Icon(
  //             Icons.support_agent_rounded,
  //             size: 24.sp,
  //             color: AppColor.primaryColor,
  //           ),
  //         ),
  //         SizedBox(width: 12.w),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'هل تحتاج مساعدة؟',
  //                 style: AppStyle.font14_700Weight.copyWith(
  //                   color: AppColor.titleColor,
  //                 ),
  //               ),
  //               SizedBox(height: 4.h),
  //               Text(
  //                 'تواصل مع فريق الدعم الفني',
  //                 style: AppStyle.font12_400Weight.copyWith(
  //                   color: AppColor.hintColor,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Icon(
  //           Icons.arrow_forward_ios_rounded,
  //           size: 16.sp,
  //           color: AppColor.hintColor,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
