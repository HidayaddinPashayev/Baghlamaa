class Validators {
  // Phone number validation - Azerbaijan format (10 digits after +994)
  static bool isValidAzerbaijanPhone(String phoneNumber) {
    if (phoneNumber.isEmpty) return false;
    // Remove any formatting
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    // Azerbaijan phone numbers have 10 digits (after country code)
    return cleaned.length == 10 && (cleaned.startsWith('5') || cleaned.startsWith('7'));
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon nömrəsi tələb olunur';
    }
    if (!isValidAzerbaijanPhone(value)) {
      return 'Keçərli Azərbaycan telefon nömrəsi daxil edin';
    }
    return null;
  }

  // Email validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tələb olunur';
    }
    if (!isValidEmail(value)) {
      return 'Keçərli email daxil edin';
    }
    return null;
  }

  // Full name validation
  static bool isValidFullName(String name) {
    return name.isNotEmpty && name.length >= 2;
  }

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ad soyadı tələb olunur';
    }
    if (value.length < 2) {
      return 'Ad soyadı ən azı 2 simvol olmalıdır';
    }
    return null;
  }

  // OTP code validation
  static bool isValidOTP(String code) {
    return code.isNotEmpty && code.length == 6 && int.tryParse(code) != null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'SMS kodu tələb olunur';
    }
    if (value.length != 6) {
      return '6 rəqəmli kod daxil edin';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Yalnız rəqəmlər daxil edin';
    }
    return null;
  }
}
