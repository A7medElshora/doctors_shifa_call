import 'package:doctors_shifa_call/features/auth/presentation/screens/loginScreen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_style.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/login_cubit.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/login_state.dart';
import 'package:doctors_shifa_call/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 1.sw,
            height: 300.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF68C3A2), Color(0xFF20BAC9)],
              ),
            ),
          ),
          SafeArea(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state.status == AuthStatus.initial) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(isOnline: true),
                    ),
                  );
                } else if (state.status == AuthStatus.failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(state.errorMessage ?? 'فشل تسجيل الخروج')),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              LocaleKeys.settings.tr(),
                              style: AppStyle.font20_600Weight.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Container(
                        width: 1.sw,
                        decoration: BoxDecoration(
                          color: AppColor.containerColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.r),
                            topRight: Radius.circular(50.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.w, vertical: 30.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'اعدادات الحساب ',
                                style: AppStyle.font18_600Weight.copyWith(
                                  color: const Color(0xFF1A3C34),
                                ),
                              ),
                              SizedBox(height: 30.h),
                              SizedBox(
                                width: double.infinity,
                                height: 50.h,
                                child: ElevatedButton(
                                  onPressed: state.status == AuthStatus.loading
                                      ? null
                                      : () {
                                          context.read<AuthCubit>().logout();
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE57373),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: state.status == AuthStatus.loading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          LocaleKeys.logout.tr(),
                                          style: AppStyle.font18_600Weight
                                              .copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
