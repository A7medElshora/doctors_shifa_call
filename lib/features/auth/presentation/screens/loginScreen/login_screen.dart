import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_style.dart';
import 'package:doctors_shifa_call/core/utils/constant/constants.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/login_cubit.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/login_state.dart';
import 'package:doctors_shifa_call/features/auth/presentation/screens/registrationScreen/registration_screen.dart';
import 'package:doctors_shifa_call/features/auth/presentation/screens/account_inactive_screen.dart';
import 'package:doctors_shifa_call/features/home/presentation/screens/home_screen.dart';
import 'package:doctors_shifa_call/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.isOnline});

  final bool isOnline;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _stayLoggedIn = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تمت إزالة context.read<AuthCubit>().checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success &&
              state.loginResponse != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomeScreen(
                  username: state.loginResponse!.userName,
                  fullName: state.loginResponse!.doctor?.name ?? '',
                  doctorId: state.loginResponse!.doctorId.toString(),
                ),
              ),
            );
          } else if (state.status == AuthStatus.inactive &&
                     state.loginResponse != null) {
            // توجيه المستخدم لصفحة الحساب غير المفعل
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => AccountInactiveScreen(
                  username: userNameController.text,
                  password: passwordController.text,
                ),
              ),
            );
          } else if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'فشل تسجيل الدخول')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SizedBox(
              width: 1.sw,
              height: 1.sh,
              child: Stack(
                children: [
                  Container(
                    width: 1.sw,
                    height: 600.h,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF68C3A2), Color(0xFF20BAC9)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 60.w,
                    child: SvgPicture.asset('assets/images/svgs/up_shadow.svg'),
                  ),
                  Positioned(
                    top: 400.h,
                    child: Container(
                      width: 430.w,
                      height: 520.h,
                      decoration: BoxDecoration(
                        color: AppColor.containerColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.r),
                          topRight: Radius.circular(50.r),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.w, vertical: 20.h),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 20.h),
                                Text(
                                  LocaleKeys.login.tr(),
                                  style: AppStyle.font20_600Weight.copyWith(
                                    color: const Color(0xFF1A3C34),
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: userNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال اسم المستخدم';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      disabledBorder: AppStyle.borderDone(),
                                      enabledBorder: AppStyle.borderDone(),
                                      border: AppStyle.borderDone(),
                                      focusedBorder: AppStyle.borderFocuse(),
                                      errorBorder:
                                          AppStyle.borderError(context),
                                      hintText: LocaleKeys.user_name.tr(),
                                      hintStyle:
                                          AppStyle.font14_400Weight.copyWith(
                                        color: const Color(0xFF8A9CA3),
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 16.sp),
                                        child: SvgPicture.asset(
                                            'assets/images/svgs/user_name.svg'),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                        horizontal: 16.w,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: passwordController,
                                    obscureText: _obscureText,
                                    textAlign: TextAlign.right,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'الرجاء إدخال كلمة المرور';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      disabledBorder: AppStyle.borderDone(),
                                      enabledBorder: AppStyle.borderDone(),
                                      border: AppStyle.borderDone(),
                                      focusedBorder: AppStyle.borderFocuse(),
                                      errorBorder:
                                          AppStyle.borderError(context),
                                      hintText: LocaleKeys.password.tr(),
                                      hintStyle:
                                          AppStyle.font14_700Weight.copyWith(
                                        color: const Color(0xFF8A9CA3),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: const Color(0xff68C3A2),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      ),
                                      prefix: Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            start: 16.sp),
                                        child: SvgPicture.asset(
                                            'assets/images/svgs/loack.svg'),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      LocaleKeys.stay_logged_in.tr(),
                                      style: AppStyle.font14_400Weight.copyWith(
                                        color: const Color(0xFF58595B),
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.tajawal().fontFamily,
                                      ),
                                    ),
                                    Switch(
                                      value: _stayLoggedIn,
                                      onChanged: (value) {
                                        setState(() {
                                          _stayLoggedIn = value;
                                        });
                                      },
                                      inactiveThumbColor: AppColor.switchColor,
                                      activeThumbColor: AppColor.primaryColor,
                                      activeTrackColor: AppColor.switchColor,
                                      inactiveTrackColor: Colors.white,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50.h,
                                  child: ElevatedButton.icon(
                                    onPressed: state.status ==
                                            AuthStatus.loading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context.read<AuthCubit>().login(
                                                    userNameController.text,
                                                    passwordController.text,
                                                  );
                                            }
                                          },
                                    icon: Text(
                                      LocaleKeys.login.tr(),
                                      style: AppStyle.font18_600Weight.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    label: Image.asset(
                                      'assets/images/seend.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF68C3A2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.status == AuthStatus.loading)
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: const CircularProgressIndicator(),
                                  ),
                                SizedBox(height: 20.h),

                                // Registration Link
                                RichText(
                                  text: TextSpan(
                                    text: 'ليس لديك حساب؟ ',
                                    style: AppStyle.font14_400Weight.copyWith(
                                      color: const Color(0xFF58595B),
                                    ),
                                    children: [
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const RegistrationScreen(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'تسجيل حساب جديد',
                                            style: AppStyle.font14_600Weight
                                                .copyWith(
                                              color: AppColor.primaryColor,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 180.h,
                    left: 0,
                    right: 0,
                    child:
                        SvgPicture.asset('assets/images/svgs/white_logo.svg'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
