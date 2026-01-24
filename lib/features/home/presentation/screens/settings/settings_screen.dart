import 'dart:convert';
import 'package:doctors_shifa_call/core/utils/cache/cache_helper.dart';
import 'package:doctors_shifa_call/features/auth/data/models/doctor_profile.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/registration_cubit.dart';
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

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  DoctorProfile? _doctorProfile;
  bool _isLoadingProfile = true;
  int _doctorAge = 0;
  String? _doctorPhotoUrl;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadDoctorProfile();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctorProfile() async {
    setState(() {
      _isLoadingProfile = true;
    });

    // 1. Try to load from Login Cache first (the new data structure)
    final String doctorName = CacheHelper.getString(key: 'doctor_name');
    if (doctorName.isNotEmpty) {
      final String birthDateStr =
          CacheHelper.getString(key: 'doctor_birth_date');
      if (birthDateStr.isNotEmpty) {
        try {
          final birthDate = DateTime.parse(birthDateStr);
          final now = DateTime.now();
          _doctorAge = now.year - birthDate.year;
          if (now.month < birthDate.month ||
              (now.month == birthDate.month && now.day < birthDate.day)) {
            _doctorAge--;
          }
        } catch (e) {
          debugPrint('Error parsing birth date: $e');
        }
      }

      final String photoName = CacheHelper.getString(key: 'doctor_photo');
      if (photoName.isNotEmpty) {
        _doctorPhotoUrl =
            'https://185.135.137.90:44302/doctor_images/$photoName';
      }

      _doctorProfile = DoctorProfile(
        name: doctorName,
        email: CacheHelper.getString(key: 'doctor_profile_email'),
        mobile: CacheHelper.getString(key: 'doctor_mobile'),
        address: CacheHelper.getString(key: 'doctor_address'),
        birthDate: birthDateStr,
        university: CacheHelper.getString(key: 'doctor_profile_university'),
        specialityId:
            CacheHelper.getInteger(key: 'doctor_profile_specialityId'),
        specialityDesc: CacheHelper.getString(key: 'doctor_speciality'),
        photo: photoName,
      );
    } else {
      // 2. Fallback to Registration Cache
      final profile =
          await context.read<RegistrationCubit>().loadDoctorProfile();
      _doctorProfile = profile;

      if (profile != null && profile.birthDate.isNotEmpty) {
        try {
          final birthDate = DateTime.parse(profile.birthDate);
          final now = DateTime.now();
          _doctorAge = now.year - birthDate.year;
          if (now.month < birthDate.month ||
              (now.month == birthDate.month && now.day < birthDate.day)) {
            _doctorAge--;
          }
        } catch (_) {}
      }
    }

    if (mounted) {
      setState(() {
        _isLoadingProfile = false;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: BlocConsumer<AuthCubit, AuthState>(
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
                content: Text(state.errorMessage ?? 'فشل تسجيل الخروج'),
                backgroundColor: AppColor.redButtonColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // App Bar مخصص مع تصميم متدرج
              SliverAppBar(
                expandedHeight: 200.h,
                floating: false,
                pinned: true,
                backgroundColor: AppColor.primaryColor,
                leading: Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20.sp),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF68C3A2), Color(0xFF20BAC9)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // دوائر ديكور
                        Positioned(
                          top: -50.h,
                          right: -30.w,
                          child: Container(
                            width: 150.w,
                            height: 150.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          left: -40.w,
                          child: Container(
                            width: 100.w,
                            height: 100.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                        ),
                        // العنوان
                        Positioned(
                          bottom: 30.h,
                          left: 24.w,
                          right: 24.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.settings.tr(),
                                style: AppStyle.font24_700Weight.copyWith(
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'إدارة حسابك وتفضيلاتك',
                                style: AppStyle.font14_400Weight.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // المحتوى الرئيسي
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // قسم الملف الشخصي
                        if (_isLoadingProfile)
                          _buildLoadingProfileSection()
                        else if (_doctorProfile != null)
                          _buildDoctorProfileSection()
                        else
                          _buildNoProfileSection(),

                        SizedBox(height: 24.h),

                        // عنوان قسم الإعدادات
                        // _buildSectionTitle('إعدادات الحساب'),

                        SizedBox(height: 16.h),

                        // خيارات الإعدادات
                        _buildSettingsOptions(),

                        SizedBox(height: 24.h),

                        // عنوان قسم آخر
                        // _buildSectionTitle('المزيد'),

                        SizedBox(height: 16.h),

                        // خيارات إضافية
                        _buildMoreOptions(),

                        SizedBox(height: 32.h),

                        // زر تسجيل الخروج
                        _buildLogoutButton(state),

                        SizedBox(height: 24.h),

                        // معلومات الإصدار
                        Center(
                          child: Text(
                            'الإصدار 1.0.0',
                            style: AppStyle.font12_400Weight.copyWith(
                              color: AppColor.hintColor,
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            title,
            style: AppStyle.font16_700Weight.copyWith(
              color: AppColor.titleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // child: Column(
      //   children: [
      //     _buildSettingItem(
      //       icon: Icons.person_outline_rounded,
      //       title: 'تعديل الملف الشخصي',
      //       subtitle: 'تحديث معلوماتك الشخصية',
      //       onTap: () {
      //         // TODO: Navigate to edit profile
      //       },
      //     ),
      //     _buildDivider(),
      //     _buildSettingItem(
      //       icon: Icons.notifications_outlined,
      //       title: 'الإشعارات',
      //       subtitle: 'إدارة تنبيهات التطبيق',
      //       trailing: Switch(
      //         value: true,
      //         onChanged: (value) {},
      //         activeThumbColor: AppColor.primaryColor,
      //       ),
      //       onTap: () {},
      //     ),
      //     _buildDivider(),
      //     _buildSettingItem(
      //       icon: Icons.language_rounded,
      //       title: 'اللغة',
      //       subtitle: 'العربية',
      //       onTap: () {
      //         // TODO: Navigate to language settings
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildMoreOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // child: Column(
      //   children: [
      //     _buildSettingItem(
      //       icon: Icons.help_outline_rounded,
      //       title: 'المساعدة والدعم',
      //       subtitle: 'الأسئلة الشائعة والتواصل',
      //       onTap: () {
      //         // TODO: Navigate to help
      //       },
      //     ),
      //     _buildDivider(),
      //     _buildSettingItem(
      //       icon: Icons.privacy_tip_outlined,
      //       title: 'سياسة الخصوصية',
      //       subtitle: 'اقرأ شروط الاستخدام',
      //       onTap: () {
      //         // TODO: Navigate to privacy
      //       },
      //     ),
      //     _buildDivider(),
      //     _buildSettingItem(
      //       icon: Icons.info_outline_rounded,
      //       title: 'عن التطبيق',
      //       subtitle: 'معلومات عن شفاء',
      //       onTap: () {
      //         // TODO: Navigate to about
      //       },
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: AppColor.primaryColor,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppStyle.font14_600Weight.copyWith(
                        color: AppColor.titleColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppStyle.font12_400Weight.copyWith(
                        color: AppColor.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColor.hintColor,
                    size: 16.sp,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        height: 1,
        color: AppColor.borderContainerColor,
      ),
    );
  }

  Widget _buildLogoutButton(AuthState state) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFEE5A5A)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: state.status == AuthStatus.loading
              ? null
              : () async {
                  await RegistrationCubit.clearDoctorProfile();
                  if (context.mounted) {
                    context.read<AuthCubit>().logout();
                  }
                },
          borderRadius: BorderRadius.circular(16.r),
          child: Center(
            child: state.status == AuthStatus.loading
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        LocaleKeys.logout.tr(),
                        style: AppStyle.font16_600Weight.copyWith(
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingProfileSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 50.w,
            height: 50.h,
            child: CircularProgressIndicator(
              color: AppColor.primaryColor,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل البيانات...',
            style: AppStyle.font14_400Weight.copyWith(
              color: AppColor.hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoProfileSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 40.sp,
              color: AppColor.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد بيانات مسجلة',
            style: AppStyle.font16_600Weight.copyWith(
              color: AppColor.titleColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'يرجى تسجيل الدخول لعرض بياناتك',
            style: AppStyle.font13_400Weight.copyWith(
              color: AppColor.hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorProfileSection() {
    final profile = _doctorProfile!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // الجزء العلوي مع التدرج
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.primaryColor.withOpacity(0.1),
                  AppColor.secondaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              children: [
                // صورة الملف الشخصي
                _buildProfilePhoto(profile.photo),
                SizedBox(height: 16.h),

                // اسم الطبيب
                Text(
                  profile.name,
                  style: AppStyle.font18_600Weight.copyWith(
                    color: AppColor.titleColor,
                  ),
                ),
                SizedBox(height: 8.h),

                // التخصص
                if (profile.specialityDesc != null &&
                    profile.specialityDesc!.isNotEmpty)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF68C3A2), Color(0xFF20BAC9)],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      profile.specialityDesc!,
                      style: AppStyle.font12_600Weight.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // معلومات التواصل
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                _buildInfoRow(
                    Icons.phone_outlined, 'رقم الهاتف', profile.mobile),
                SizedBox(height: 14.h),
                _buildInfoRow(
                    Icons.location_on_outlined, 'العنوان', profile.address),
                SizedBox(height: 14.h),
                _buildInfoRow(Icons.cake_outlined, 'تاريخ الميلاد',
                    _formatBirthDate(profile.birthDate)),
                if (_doctorAge > 0) ...[
                  SizedBox(height: 14.h),
                  _buildInfoRow(Icons.calendar_today_outlined, 'العمر',
                      '$_doctorAge سنة'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatBirthDate(String dateStr) {
    if (dateStr.isEmpty) return 'غير محدد';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy/MM/dd').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildProfilePhoto(String? photo) {
    Widget imageWidget;

    if (_doctorPhotoUrl != null) {
      imageWidget = ClipOval(
        child: Image.network(
          _doctorPhotoUrl!,
          width: 100.w,
          height: 100.h,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.person_rounded,
            size: 50.sp,
            color: AppColor.primaryColor,
          ),
        ),
      );
    } else if (photo != null &&
        photo.isNotEmpty &&
        photo.startsWith('data:image')) {
      try {
        final base64Data = photo.split(',').last;
        final imageBytes = base64Decode(base64Data);
        imageWidget = ClipOval(
          child: Image.memory(
            imageBytes,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.cover,
          ),
        );
      } catch (e) {
        imageWidget = Icon(
          Icons.person_rounded,
          size: 50.sp,
          color: AppColor.primaryColor,
        );
      }
    } else {
      imageWidget = Icon(
        Icons.person_rounded,
        size: 50.sp,
        color: AppColor.primaryColor,
      );
    }

    return Container(
      width: 110.w,
      height: 110.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.primaryColor.withOpacity(0.1),
        ),
        child: Center(child: imageWidget),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.containerColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: AppColor.primaryColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppStyle.font12_400Weight.copyWith(
                    color: AppColor.hintColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value.isNotEmpty ? value : 'غير محدد',
                  style: AppStyle.font14_600Weight.copyWith(
                    color: AppColor.titleColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
