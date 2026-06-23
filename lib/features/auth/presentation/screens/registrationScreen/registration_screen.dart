import 'dart:io';
import 'dart:convert';

import 'package:doctors_shifa_call/core/utils/constant/app_color.dart';
import 'package:doctors_shifa_call/core/utils/constant/app_style.dart';
import 'package:doctors_shifa_call/features/auth/data/models/doctor_profile.dart';
import 'package:doctors_shifa_call/features/auth/data/models/specialty_model.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/registration_cubit.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/registration_state.dart';
import 'package:doctors_shifa_call/features/auth/presentation/screens/registrationScreen/id_card_scanner_screen.dart';
import 'package:doctors_shifa_call/features/auth/presentation/screens/registrationScreen/image_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:doctors_shifa_call/core/widgets/loading_overlay.dart';

class RegistrationScreen extends StatefulWidget {
  final bool isEditMode;
  final DoctorProfile? initialProfile;

  const RegistrationScreen({
    super.key,
    this.isEditMode = false,
    this.initialProfile,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  CancelToken? _cancelToken;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  // Selected specialty
  SpecialtyModel? _selectedSpecialty;

  // Image/File storage
  File? _profilePhoto;
  String? _existingProfilePhoto;
  File? _idFrontImage;
  File? _idBackImage;
  File? _membershipCard;
  final List<File> _certificateFiles = [];

  final ImagePicker _picker = ImagePicker();
  bool _specialtyInitialized = false;

  @override
  void initState() {
    super.initState();
    _prefillDataIfNeeded();
    // Load specialties when screen opens
    context.read<RegistrationCubit>().loadSpecialties();
  }

  void _prefillDataIfNeeded() {
    final profile = widget.initialProfile;
    if (profile == null) {
      return;
    }
    nameController.text = profile.name;
    emailController.text = profile.email;
    phoneController.text = profile.mobile;
    addressController.text = profile.address;
    universityController.text = profile.university;
    _existingProfilePhoto = profile.photo;

    if (profile.birthDate.isNotEmpty) {
      try {
        final birthDate = DateTime.parse(profile.birthDate);
        final now = DateTime.now();
        var age = now.year - birthDate.year;
        if (now.month < birthDate.month ||
            (now.month == birthDate.month && now.day < birthDate.day)) {
          age--;
        }
        if (age > 0) {
          ageController.text = age.toString();
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        if (!_specialtyInitialized &&
            widget.initialProfile != null &&
            state.specialties.isNotEmpty) {
          SpecialtyModel? matchedSpecialty;
          for (final item in state.specialties) {
            if (item.specialityId == widget.initialProfile!.specialityId) {
              matchedSpecialty = item;
              break;
            }
          }
          _selectedSpecialty = matchedSpecialty;
          _specialtyInitialized = true;
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              // Gradient Background
              Container(
                width: 1.sw,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF68C3A2), Color(0xFF20BAC9)],
                  ),
                ),
              ),

              // Top Shadow
              Positioned(
                top: 30,
                left: 0,
                right: 60.w,
                child: SvgPicture.asset('assets/images/svgs/up_shadow.svg',
                    width: 150.w, height: 220.h, fit: BoxFit.fill),
              ),

              // Logo
              Positioned(
                top: 120.h,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/images/svgs/white_logo.svg',
                  height: 80.h,
                ),
              ),

              // Main Content - Form Container
              Positioned.fill(
                top: 250.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.containerColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: BlocConsumer<RegistrationCubit, RegistrationState>(
                    listener: (context, state) {
                      if (state.status == RegistrationStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(widget.isEditMode
                                ? 'تم حفظ التعديلات بنجاح'
                                : 'تم إرسال طلب التسجيل بنجاح! سيتم مراجعته قريباً'),
                            backgroundColor: AppColor.primaryColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                        });
                      } else if (state.status == RegistrationStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage ??
                                (widget.isEditMode
                                    ? 'حدث خطأ أثناء تعديل البيانات'
                                    : 'حدث خطأ في التسجيل')),
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
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 30.h),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Title
                              Text(
                                widget.isEditMode
                                    ? 'تعديل بيانات الحساب'
                                    : 'تسجيل حساب جديد',
                                style: AppStyle.font20_600Weight.copyWith(
                                  color: const Color(0xFF1A3C34),
                                  fontSize: 24.sp,
                                ),
                              ),

                              SizedBox(height: 30.h),

                              // Profile Photo
                              _buildProfilePhotoSection(),

                              SizedBox(height: 20.h),

                              // Name Field
                              _buildTextField(
                                controller: nameController,
                                hintText: 'الاسم الكامل',
                                icon: 'assets/images/svgs/user_name.svg',
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'الرجاء إدخال الاسم الكامل';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Email Field
                              _buildTextField(
                                controller: emailController,
                                hintText: 'البريد الإلكتروني',
                                icon: 'assets/images/svgs/user_name.svg',
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'الرجاء إدخال البريد الإلكتروني';
                                  }
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'البريد الإلكتروني غير صحيح';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Phone Field
                              _buildTextField(
                                controller: phoneController,
                                hintText: 'رقم الهاتف',
                                icon: 'assets/images/svgs/user_name.svg',
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                maxLength: 11,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'الرجاء إدخال رقم الهاتف';
                                  }
                                  if (value.trim().length != 11) {
                                    return 'رقم الهاتف يجب أن يكون 11 رقماً';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Address Field
                              _buildTextField(
                                controller: addressController,
                                hintText: 'العنوان',
                                icon: 'assets/images/svgs/user_name.svg',
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'الرجاء إدخال العنوان';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Age Field
                              _buildAgeField(),
                              SizedBox(height: 20.h),

                              // University Field
                              _buildTextField(
                                controller: universityController,
                                hintText: 'الجامعة',
                                icon: 'assets/images/svgs/user_name.svg',
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'الرجاء إدخال اسم الجامعة';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Specialty Dropdown
                              _buildSpecialtyDropdown(state),
                              SizedBox(height: 20.h),

                              // Password Field
                              _buildPasswordField(
                                controller: passwordController,
                                hintText: 'كلمة المرور',
                                obscureText: _obscurePassword,
                                onToggle: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال كلمة المرور';
                                  }
                                  if (value.length < 6) {
                                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),

                              // Confirm Password Field
                              _buildPasswordField(
                                controller: confirmPasswordController,
                                hintText: 'تأكيد كلمة المرور',
                                obscureText: _obscureConfirmPassword,
                                onToggle: () => setState(() =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء تأكيد كلمة المرور';
                                  }
                                  if (value != passwordController.text) {
                                    return 'كلمة المرور غير متطابقة';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 30.h),

                              // Required Documents Section
                              Container(
                                padding: EdgeInsets.all(20.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'المستندات المطلوبة *',
                                      style: AppStyle.font16_600Weight.copyWith(
                                        color: const Color(0xFF1A3C34),
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    _buildIdUploadCard(
                                      title: 'الوجه الأمامي للبطاقة *',
                                      image: _idFrontImage,
                                      onTap: () => _showImageSourceDialog(
                                          ImageType.idFront),
                                      onView: _idFrontImage != null
                                          ? () => _viewImage(
                                              _idFrontImage!, 'الوجه الأمامي')
                                          : null,
                                      isFront: true,
                                    ),
                                    SizedBox(height: 15.h),
                                    _buildIdUploadCard(
                                      title: 'الوجه الخلفي للبطاقة *',
                                      image: _idBackImage,
                                      onTap: () => _showImageSourceDialog(
                                          ImageType.idBack),
                                      onView: _idBackImage != null
                                          ? () => _viewImage(
                                              _idBackImage!, 'الوجه الخلفي')
                                          : null,
                                      isFront: false,
                                    ),
                                    SizedBox(height: 15.h),
                                    _buildIdUploadCard(
                                      title: 'كارت النقابة *',
                                      image: _membershipCard,
                                      onTap: () => _showImageSourceDialog(
                                          ImageType.membershipCard),
                                      onView: _membershipCard != null
                                          ? () => _viewImage(
                                              _membershipCard!, 'كارت النقابة')
                                          : null,
                                      isFront: true,
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      'الشهادات والمستندات الإضافية (اختياري)',
                                      style: AppStyle.font16_600Weight.copyWith(
                                        color: const Color(0xFF1A3C34),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    if (_certificateFiles.isNotEmpty)
                                      ...List.generate(_certificateFiles.length,
                                          (index) {
                                        return Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 10.h),
                                          child: _buildCertificateCard(
                                            file: _certificateFiles[index],
                                            index: index,
                                            onRemove: () {
                                              setState(() {
                                                _certificateFiles
                                                    .removeAt(index);
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                    InkWell(
                                      onTap: () =>
                                          _pickImage(ImageType.certificate),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.h, horizontal: 15.w),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          border: Border.all(
                                            color: AppColor.primaryColor
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              color: AppColor.primaryColor,
                                              size: 24.sp,
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              'إضافة شهادة أو مستند',
                                              style: AppStyle.font14_600Weight
                                                  .copyWith(
                                                color: AppColor.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30.h),

                              // Register Button
                              SizedBox(
                                width: double.infinity,
                                height: 50.h,
                                child: ElevatedButton.icon(
                                  onPressed: state.status ==
                                          RegistrationStatus.registering
                                      ? null
                                      : _handleRegister,
                                  icon: state.status ==
                                          RegistrationStatus.registering
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          widget.isEditMode
                                              ? 'حفظ التعديلات'
                                              : 'تسجيل',
                                          style: AppStyle.font18_600Weight
                                              .copyWith(color: Colors.white),
                                        ),
                                  label: state.status ==
                                          RegistrationStatus.registering
                                      ? const SizedBox.shrink()
                                      : Image.asset(
                                          'assets/images/seend.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF68C3A2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    elevation: 3,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // Login Link
                              if (!widget.isEditMode)
                                RichText(
                                  text: TextSpan(
                                    text: 'لديك حساب بالفعل؟ ',
                                    style: AppStyle.font14_400Weight.copyWith(
                                      color: const Color(0xFF58595B),
                                    ),
                                    children: [
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Text(
                                            'تسجيل الدخول',
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
                              SizedBox(height: 40.h),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              if (state.status == RegistrationStatus.registering)
                LoadingOverlay(
                  message: 'جاري إنشاء حسابك...',
                  onCancel: () {
                    _cancelToken?.cancel('User cancelled registration');
                    _cancelToken = null;
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfilePhotoSection() {
    return Center(
      child: GestureDetector(
        onTap: () => _pickImage(ImageType.profilePhoto),
        child: Stack(
          children: [
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primaryColor.withOpacity(0.1),
                border: Border.all(
                  color: AppColor.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipOval(child: _buildCurrentProfilePhotoWidget()),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentProfilePhotoWidget() {
    if (_profilePhoto != null) {
      return Image.file(
        _profilePhoto!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    final photo = _existingProfilePhoto;
    if (photo != null && photo.isNotEmpty) {
      if (photo.startsWith('data:image')) {
        try {
          final base64Data = photo.split(',').last;
          final bytes = base64Decode(base64Data);
          return Image.memory(
            bytes,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        } catch (_) {}
      }

      final resolvedPhotoUrl = photo.startsWith('http')
          ? photo
          : 'https://185.135.137.90:44302/doctor_images/$photo';

      return Image.network(
        resolvedPhotoUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => Icon(
          Icons.person,
          size: 50.sp,
          color: AppColor.primaryColor,
        ),
      );
    }

    return Icon(
      Icons.person,
      size: 50.sp,
      color: AppColor.primaryColor,
    );
  }

  Widget _buildAgeField() {
    return Container(
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
        controller: ageController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'الرجاء إدخال السن';
          }
          if (int.tryParse(value) == null) {
            return 'السن يجب أن يكون رقماً';
          }
          return null;
        },
        decoration: InputDecoration(
          disabledBorder: AppStyle.borderDone(),
          enabledBorder: AppStyle.borderDone(),
          border: AppStyle.borderDone(),
          focusedBorder: AppStyle.borderFocuse(),
          errorBorder: AppStyle.borderError(context),
          hintText: 'السن',
          hintStyle: AppStyle.font14_400Weight.copyWith(
            color: const Color(0xFF8A9CA3),
          ),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 16.sp),
            child: Icon(Icons.cake, color: AppColor.primaryColor),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 16.w,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialtyDropdown(RegistrationState state) {
    if (state.status == RegistrationStatus.loading) {
      return Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
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
      child: DropdownButtonFormField<int>(
        initialValue: _selectedSpecialty?.specialityId,
        isExpanded: true,
        decoration: InputDecoration(
          disabledBorder: AppStyle.borderDone(),
          enabledBorder: AppStyle.borderDone(),
          border: AppStyle.borderDone(),
          focusedBorder: AppStyle.borderFocuse(),
          errorBorder: AppStyle.borderError(context),
          hintText: 'اختر التخصص',
          hintStyle: AppStyle.font14_400Weight.copyWith(
            color: const Color(0xFF8A9CA3),
          ),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 16.sp),
            child: Icon(Icons.medical_services, color: AppColor.primaryColor),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 16.w,
          ),
        ),
        items: state.specialties.map((specialty) {
          return DropdownMenuItem<int>(
            value: specialty.specialityId,
            child: Text(
              specialty.specialityDesc,
              style: AppStyle.font14_400Weight.copyWith(
                color: const Color(0xFF1A3C34),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            if (value == null) {
              _selectedSpecialty = null;
              return;
            }

            _selectedSpecialty = state.specialties.firstWhere(
              (specialty) => specialty.specialityId == value,
              orElse: () => SpecialtyModel(
                specialityId: value,
                specialityDesc: '',
              ),
            );
          });
        },
        validator: (value) {
          if (value == null) {
            return 'الرجاء اختيار التخصص';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Container(
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
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          counterText: '',
          disabledBorder: AppStyle.borderDone(),
          enabledBorder: AppStyle.borderDone(),
          border: AppStyle.borderDone(),
          focusedBorder: AppStyle.borderFocuse(),
          errorBorder: AppStyle.borderError(context),
          hintText: hintText,
          hintStyle: AppStyle.font14_400Weight.copyWith(
            color: const Color(0xFF8A9CA3),
          ),
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 16.sp),
            child: SvgPicture.asset(icon),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 16.w,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Container(
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
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          disabledBorder: AppStyle.borderDone(),
          enabledBorder: AppStyle.borderDone(),
          border: AppStyle.borderDone(),
          focusedBorder: AppStyle.borderFocuse(),
          errorBorder: AppStyle.borderError(context),
          hintText: hintText,
          hintStyle: AppStyle.font14_700Weight.copyWith(
            color: const Color(0xFF8A9CA3),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xff68C3A2),
            ),
            onPressed: onToggle,
          ),
          prefix: Padding(
            padding: EdgeInsetsDirectional.only(start: 16.sp),
            child: SvgPicture.asset('assets/images/svgs/loack.svg'),
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateCard({
    required File file,
    required VoidCallback onRemove,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.secondaryColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _viewImage(file, 'شهادة ${index + 1}'),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColor.secondaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _viewImage(file, 'شهادة ${index + 1}'),
                  child: Container(
                    width: 55.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                            width: 55.w,
                            height: 55.h,
                          ),
                        ),
                        Positioned(
                          right: 2,
                          bottom: 2,
                          child: Container(
                            padding: EdgeInsets.all(2.r),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            child: Icon(
                              Icons.zoom_in,
                              color: Colors.white,
                              size: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 16.sp,
                            color: AppColor.secondaryColor,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            'شهادة ${index + 1}',
                            style: AppStyle.font14_600Weight.copyWith(
                              color: const Color(0xFF1A3C34),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'اضغط للعرض',
                        style: AppStyle.font12_400Weight.copyWith(
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.redButtonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: IconButton(
                    onPressed: onRemove,
                    icon: Icon(
                      Icons.delete_outline,
                      color: AppColor.redButtonColor,
                      size: 22.sp,
                    ),
                    padding: EdgeInsets.all(8.r),
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdUploadCard({
    required String title,
    required File? image,
    required VoidCallback onTap,
    VoidCallback? onView,
    required bool isFront,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: image != null
                ? AppColor.primaryColor.withOpacity(0.15)
                : Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            decoration: BoxDecoration(
              gradient: image != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.primaryColor.withOpacity(0.08),
                        AppColor.secondaryColor.withOpacity(0.05),
                      ],
                    )
                  : null,
              color: image == null ? Colors.white : null,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: image != null
                    ? AppColor.primaryColor
                    : Colors.grey.withOpacity(0.2),
                width: image != null ? 2 : 1.5,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: image != null && onView != null ? onView : onTap,
                  child: Container(
                    width: 80.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: image != null
                          ? Colors.transparent
                          : AppColor.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: image == null
                          ? Border.all(
                              color: AppColor.primaryColor.withOpacity(0.3),
                              width: 2,
                              style: BorderStyle.solid,
                            )
                          : null,
                      boxShadow: image != null
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(
                              image,
                              fit: BoxFit.cover,
                              width: 80.w,
                              height: 60.h,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isFront
                                    ? Icons.credit_card
                                    : Icons.credit_card_outlined,
                                color: AppColor.primaryColor,
                                size: 22.sp,
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppStyle.font14_600Weight.copyWith(
                                color: const Color(0xFF1A3C34),
                              ),
                            ),
                          ),
                          if (image != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColor.primaryColor,
                                    size: 12.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'تم',
                                    style: AppStyle.font12_400Weight.copyWith(
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(
                            image != null
                                ? Icons.touch_app
                                : Icons.camera_alt_outlined,
                            size: 14.sp,
                            color: image != null
                                ? AppColor.secondaryColor
                                : const Color(0xFF8A9CA3),
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              image != null
                                  ? 'اضغط على الصورة لعرضها أو هنا لتغييرها'
                                  : 'التقط صورة أو اختر من المعرض',
                              style: AppStyle.font12_400Weight.copyWith(
                                color: image != null
                                    ? AppColor.secondaryColor
                                    : const Color(0xFF8A9CA3),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(ImageType type) {
    final title = switch (type) {
      ImageType.idFront => 'الوجه الأمامي للبطاقة',
      ImageType.idBack => 'الوجه الخلفي للبطاقة',
      ImageType.membershipCard => 'كارت النقابة',
      _ => 'صورة',
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.r),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'رفع $title',
                  style: AppStyle.font18_600Weight.copyWith(
                    color: const Color(0xFF1A3C34),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'اختر طريقة الرفع',
                  style: AppStyle.font14_400Weight.copyWith(
                    color: const Color(0xFF8A9CA3),
                  ),
                ),
                SizedBox(height: 25.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildSourceOption(
                        icon: Icons.camera_alt_rounded,
                        title: 'الكاميرا',
                        subtitle: 'التقط صورة مباشرة',
                        color: AppColor.primaryColor,
                        onTap: () {
                          Navigator.pop(context);
                          _openIdScanner(type);
                        },
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: _buildSourceOption(
                        icon: Icons.photo_library_rounded,
                        title: 'المعرض',
                        subtitle: 'اختر من الصور',
                        color: AppColor.secondaryColor,
                        onTap: () {
                          Navigator.pop(context);
                          _pickFromGallery(type);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: AppStyle.font14_600Weight.copyWith(
                color: const Color(0xFF1A3C34),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: AppStyle.font12_400Weight.copyWith(
                color: const Color(0xFF8A9CA3),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openIdScanner(ImageType type) async {
    final isFront = type == ImageType.idFront;
    final title = switch (type) {
      ImageType.idFront => 'الوجه الأمامي للبطاقة',
      ImageType.idBack => 'الوجه الخلفي للبطاقة',
      ImageType.membershipCard => 'كارت النقابة',
      _ => 'صورة',
    };

    final File? result = await Navigator.push<File>(
      context,
      MaterialPageRoute(
        builder: (context) => IdCardScannerScreen(
          title: title,
          isFront: isFront,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        switch (type) {
          case ImageType.idFront:
            _idFrontImage = result;
            break;
          case ImageType.idBack:
            _idBackImage = result;
            break;
          case ImageType.membershipCard:
            _membershipCard = result;
            break;
          default:
            break;
        }
      });
    }
  }

  Future<void> _pickFromGallery(ImageType type) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case ImageType.idFront:
            _idFrontImage = File(pickedFile.path);
            break;
          case ImageType.idBack:
            _idBackImage = File(pickedFile.path);
            break;
          case ImageType.membershipCard:
            _membershipCard = File(pickedFile.path);
            break;
          case ImageType.certificate:
            _certificateFiles.add(File(pickedFile.path));
            break;
          case ImageType.profilePhoto:
            _profilePhoto = File(pickedFile.path);
            break;
        }
      });
    }
  }

  void _viewImage(File image, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(
          image: image,
          title: title,
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageType type) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case ImageType.idFront:
            _idFrontImage = File(pickedFile.path);
            break;
          case ImageType.idBack:
            _idBackImage = File(pickedFile.path);
            break;
          case ImageType.membershipCard:
            _membershipCard = File(pickedFile.path);
            break;
          case ImageType.certificate:
            _certificateFiles.add(File(pickedFile.path));
            break;
          case ImageType.profilePhoto:
            _profilePhoto = File(pickedFile.path);
            break;
        }
      });
    }
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (!widget.isEditMode &&
          (_idFrontImage == null ||
              _idBackImage == null ||
              _membershipCard == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('يجب رفع وجهي البطاقة وكارت النقابة'),
            backgroundColor: AppColor.redButtonColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
        return;
      }

      if (_selectedSpecialty == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('الرجاء اختيار التخصص'),
            backgroundColor: AppColor.redButtonColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
        return;
      }

      String birthDateString = '';
      if (ageController.text.isNotEmpty) {
        int age = int.tryParse(ageController.text.trim()) ?? 0;
        // Calculate birth year based on age
        final birthDate = DateTime(DateTime.now().year - age, 1, 1);
        birthDateString = DateFormat('yyyy-MM-dd').format(birthDate);
      }

      // Initialize cancel token
      _cancelToken = CancelToken();

      if (widget.isEditMode) {
        context.read<RegistrationCubit>().updateDoctorProfile(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text,
              mobile: phoneController.text.trim(),
              address: addressController.text.trim(),
              birthDate: birthDateString,
              university: universityController.text.trim(),
              specialityId: _selectedSpecialty!.specialityId,
              photo: _profilePhoto,
              existingPhoto: widget.initialProfile?.photo,
              nationalIdPhotoFront: _idFrontImage,
              nationalIdPhotoBack: _idBackImage,
              membershipCard: _membershipCard,
              additionalPhotos: _certificateFiles,
              cancelToken: _cancelToken,
            );
      } else {
        // Call the registration API
        context.read<RegistrationCubit>().registerDoctor(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text,
              mobile: phoneController.text.trim(),
              address: addressController.text.trim(),
              birthDate: birthDateString,
              university: universityController.text.trim(),
              specialityId: _selectedSpecialty!.specialityId,
              photo: _profilePhoto,
              nationalIdPhotoFront: _idFrontImage!,
              nationalIdPhotoBack: _idBackImage!,
              membershipCard: _membershipCard!,
              additionalPhotos: _certificateFiles,
              cancelToken: _cancelToken,
            );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    universityController.dispose();
    ageController.dispose();
    super.dispose();
  }
}

enum ImageType {
  idFront,
  idBack,
  certificate,
  membershipCard,
  profilePhoto,
}
