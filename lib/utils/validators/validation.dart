class TValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required.";
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid Email Address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.";
    }
    //    check for minimum password length
    if (value.length < 6) {
      return "Password must contain at least 6 characters";
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required.";
    }
    //Regular expression for phone number validation
    /*final phoneRegExp =
        RegExp(r'^[+]{1}(?:[0-9\\-\\(\\)\\/" \"\\.]\\s?){6,15}[0-9]{1}$');*/
    final phoneRegExp = RegExp(r'^(\+?880|0)?1[3-9]\d{8}$');
    //    check for minimum password length
    if (!phoneRegExp.hasMatch(value)) {
      return "Invalid phone number format";
    }
    return null;
  }
}
