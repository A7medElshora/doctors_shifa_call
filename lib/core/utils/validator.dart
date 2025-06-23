class Validator {
  static String? displayNamevalidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display name must be between 3 and 20 characters';
    }

    return null;
  }

  static String? validateMobile(String? value) {
    const String pattern = r'^(10|11|12|15)\d{8}$';
    final RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return "Mobile number is required";
    } else if (!regExp.hasMatch(value)) {
      if (value.startsWith('10') ||
          value.startsWith('11') ||
          value.startsWith('12') ||
          value.startsWith('15')) {
        return "Mobile Number must 10 digits";
      } else {
        return "Mobile Number must start with (10, 11, 12, 15)";
      }
    }

    return null;
  }

  static bool? isValidateMobile(String? value) {
    const String pattern = r'^(10|11|12|15)[0-9]{8}$';
    final RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return true;
    } else if (value.length != 10) {
      return true;
    } else if (!regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static bool? isDisplayNamevalidator(String? value) {
    if (value!.isEmpty) {
      return false;
    }
    if (value.length < 6) {
      return false;
    }
    return true;
  }

  static bool? isEditDisplayNamevalidator(String? value) {
    if (value!.isEmpty) {
      return true;
    }
    if (value.length < 6) {
      return true;
    }
    return false;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (passwordValidator(value) != null) {
      return passwordValidator(value);
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value!.isEmpty) {
      return 'enterPhoneVer';
    } else if (value.length < 10) {
      return 'enterPhoneVer';
    }
    return null;
  }

  static String? validatePhoneAllowEmpty(String? value) {
    if (value != null && value.isNotEmpty && value.length < 10) {
      return 'enterPhoneVer';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    const String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return "Please enter an email";
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email';
    } else {
      return null;
    }
  }

  static String? validateAddress(String? value) {
    if (value!.isEmpty || value.length < 5) {
      return 'Address is not valid';
    }
    return null;
  }

  static String? validateDay(String? value) {
    if (value!.isEmpty) {
      return 'Required';
    } else if (int.tryParse(value)! > 31) {
      return 'Not Valid';
    }
    return null;
  }

  static String? validateMonth(String? value) {
    if (value!.isEmpty) {
      return 'Required';
    } else if (int.tryParse(value)! > 12) {
      return 'Not Valid';
    }
    return null;
  }

  static String? validateYear(String? value) {
    if (value!.isEmpty) {
      return 'Required';
    } else if (int.tryParse(value)! > (DateTime.now().year - 10)) {
      return 'Not Valid';
    } else if (int.tryParse(value)! < 1940) {
      return 'Not Valid';
    }
    return null;
  }
}
