class ApiConstants {
  static const String apiBaseUrl = 'https://188.245.90.186:44300/webapi/';
  static const String loginEndpoint = 'doctor_login/login';
  static const String getDaysEndpoint = 'doctor_times/getdays';
  static const String getDoctorTimeTableEndpoint =
      'doctor_times/get_doctor_time_table';
  static const String updateDoctorTimeTableEndpoint =
      'doctor_times/update_doctor_time_table';
  static const String getDoctorReservationsEndpoint =
      'doctor_times/get_doctor_reservation';

  static const String getDoctorPricesEndpoint =
      'doctore_values/get_doctor_visit_value';
  static const String updateDoctorPricesEndpoint =
      'doctore_values/update_doctor_visit_value';
}
