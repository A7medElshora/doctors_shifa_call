import 'package:equatable/equatable.dart';
import 'package:doctors_shifa_call/features/auth/data/models/specialty_model.dart';
import 'package:doctors_shifa_call/features/auth/data/models/doctor_profile.dart';

enum RegistrationStatus {
  initial,
  loading,
  specialtiesLoaded,
  registering,
  success,
  failure,
}

class RegistrationState extends Equatable {
  final RegistrationStatus status;
  final String? errorMessage;
  final List<SpecialtyModel> specialties;
  final DoctorProfile? doctorProfile;

  const RegistrationState({
    required this.status,
    this.errorMessage,
    this.specialties = const [],
    this.doctorProfile,
  });

  RegistrationState copyWith({
    RegistrationStatus? status,
    String? errorMessage,
    List<SpecialtyModel>? specialties,
    DoctorProfile? doctorProfile,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      specialties: specialties ?? this.specialties,
      doctorProfile: doctorProfile ?? this.doctorProfile,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, specialties, doctorProfile];
}
