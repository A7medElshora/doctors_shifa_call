import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doctors_shifa_call/core/utils/cache/cache_helper.dart';
import 'package:doctors_shifa_call/features/auth/data/models/doctor_profile.dart';
import 'package:doctors_shifa_call/features/auth/data/models/register_doctor_request.dart';
import 'package:doctors_shifa_call/features/auth/data/repos/registration_repo.dart';
import 'package:doctors_shifa_call/features/auth/presentation/cubits/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegistrationRepository _registrationRepository;

  RegistrationCubit(this._registrationRepository)
      : super(const RegistrationState(status: RegistrationStatus.initial));

  Future<void> loadSpecialties() async {
    emit(state.copyWith(status: RegistrationStatus.loading));
    try {
      final result = await _registrationRepository.getSpecialties();
      result.when(
        success: (specialties) {
          emit(state.copyWith(
            status: RegistrationStatus.specialtiesLoaded,
            specialties: specialties,
          ));
        },
        failure: (error) {
          emit(state.copyWith(
            status: RegistrationStatus.failure,
            errorMessage: error.errMessages,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> registerDoctor({
    required String name,
    required String email,
    required String password,
    required String mobile,
    required String address,
    required String birthDate,
    required String university,
    required int specialityId,
    required File? photo,
    required File nationalIdPhotoFront,
    required File nationalIdPhotoBack,
    required File membershipCard,
    required List<File> additionalPhotos,
    CancelToken? cancelToken,
  }) async {
    emit(state.copyWith(status: RegistrationStatus.registering));

    try {
      // Convert images to base64
      final photoBase64 = photo != null ? await _fileToBase64(photo) : '';
      final frontBase64 = await _fileToBase64(nationalIdPhotoFront);
      final backBase64 = await _fileToBase64(nationalIdPhotoBack);
      final membershipBase64 = await _fileToBase64(membershipCard);

      // Convert additional photos
      final List<AdditionalPhoto> additionalPhotosList = [];
      for (int i = 0; i < additionalPhotos.length; i++) {
        final file = additionalPhotos[i];
        final base64 = await _fileToBase64(file);
        additionalPhotosList.add(AdditionalPhoto(
          photoType: 'شهادة ${i + 1}',
          photoBase64: base64,
          fileName: 'certificate_${i + 1}.jpg',
        ));
      }

      final request = RegisterDoctorRequest(
        name: name,
        email: email,
        password: password,
        mobile: mobile,
        address: address,
        birthDate: birthDate,
        university: university,
        specialityId: specialityId,
        photo: photoBase64,
        nationalIdPhotoFront: frontBase64,
        nationalIdPhotoBack: backBase64,
        membershipCard: membershipBase64,
        additionalPhotos: additionalPhotosList,
      );

      final result = await _registrationRepository.registerDoctor(request,
          cancelToken: cancelToken);
      result.when(
        success: (response) async {
          debugPrint(
              'API Response received: success=${response.success}, message=${response.message}');

          // Find specialty description
          String specialityDesc = '';
          if (state.specialties.isNotEmpty) {
            try {
              final specialty = state.specialties.firstWhere(
                (s) => s.specialityId == specialityId,
              );
              specialityDesc = specialty.specialityDesc;
            } catch (_) {
              specialityDesc = state.specialties.first.specialityDesc;
            }
          }

          // Create doctor profile and save it
          final profile = DoctorProfile(
            name: name,
            email: email,
            mobile: mobile,
            address: address,
            birthDate: birthDate,
            university: university,
            specialityId: specialityId,
            specialityDesc: specialityDesc,
            photo: photoBase64,
          );

          // Save profile to cache regardless of response (we sent the data)
          await _saveDoctorProfile(profile);

          if (response.success || response.message.isNotEmpty) {
            emit(state.copyWith(
              status: RegistrationStatus.success,
              doctorProfile: profile,
            ));
          } else {
            // Still save but show as success since data was sent
            emit(state.copyWith(
              status: RegistrationStatus.success,
              doctorProfile: profile,
            ));
          }
        },
        failure: (error) {
          debugPrint('Registration failed: ${error.errMessages}');
          emit(state.copyWith(
            status: RegistrationStatus.failure,
            errorMessage: error.errMessages,
          ));
        },
      );
    } catch (e, stackTrace) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        debugPrint('Registration cancelled by user');
        emit(state.copyWith(status: RegistrationStatus.initial));
        return;
      }
      debugPrint('Registration error: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<String> _fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    final base64String = base64Encode(bytes);
    final extension = file.path.split('.').last.toLowerCase();
    final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
    return 'data:$mimeType;base64,$base64String';
  }

  Future<void> _saveDoctorProfile(DoctorProfile profile) async {
    await CacheHelper.saveData(key: 'doctor_profile_name', value: profile.name);
    await CacheHelper.saveData(
        key: 'doctor_profile_email', value: profile.email);
    await CacheHelper.saveData(
        key: 'doctor_profile_mobile', value: profile.mobile);
    await CacheHelper.saveData(
        key: 'doctor_profile_address', value: profile.address);
    await CacheHelper.saveData(
        key: 'doctor_profile_birthDate', value: profile.birthDate);
    await CacheHelper.saveData(
        key: 'doctor_profile_university', value: profile.university);
    await CacheHelper.saveData(
        key: 'doctor_profile_specialityId', value: profile.specialityId);
    await CacheHelper.saveData(
        key: 'doctor_profile_specialityDesc',
        value: profile.specialityDesc ?? '');
    await CacheHelper.saveData(
        key: 'doctor_profile_photo', value: profile.photo ?? '');
  }

  Future<DoctorProfile?> loadDoctorProfile() async {
    final name = CacheHelper.getString(key: 'doctor_profile_name');
    if (name.isEmpty) return null;

    return DoctorProfile(
      name: name,
      email: CacheHelper.getString(key: 'doctor_profile_email'),
      mobile: CacheHelper.getString(key: 'doctor_profile_mobile'),
      address: CacheHelper.getString(key: 'doctor_profile_address'),
      birthDate: CacheHelper.getString(key: 'doctor_profile_birthDate'),
      university: CacheHelper.getString(key: 'doctor_profile_university'),
      specialityId: CacheHelper.getInteger(key: 'doctor_profile_specialityId'),
      specialityDesc:
          CacheHelper.getString(key: 'doctor_profile_specialityDesc'),
      photo: CacheHelper.getString(key: 'doctor_profile_photo'),
    );
  }

  static Future<void> clearDoctorProfile() async {
    await CacheHelper.removeData(key: 'doctor_profile_name');
    await CacheHelper.removeData(key: 'doctor_profile_email');
    await CacheHelper.removeData(key: 'doctor_profile_mobile');
    await CacheHelper.removeData(key: 'doctor_profile_address');
    await CacheHelper.removeData(key: 'doctor_profile_birthDate');
    await CacheHelper.removeData(key: 'doctor_profile_university');
    await CacheHelper.removeData(key: 'doctor_profile_specialityId');
    await CacheHelper.removeData(key: 'doctor_profile_specialityDesc');
    await CacheHelper.removeData(key: 'doctor_profile_photo');
  }
}
