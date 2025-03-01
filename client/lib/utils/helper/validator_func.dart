
class ValidatorFunc {
  // empty validation 
  static String? emptyValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }

    return null;
  }




  static String? emailOrPhoneValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or phone number is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Regular expression for phone number validation
    final phoneRegExp = RegExp(r'^[0-9]{10}$');

    if (!emailRegExp.hasMatch(value) && !phoneRegExp.hasMatch(value)) {
      return 'Invalid email address or phone number.';
    }

    return null;
  }


  // password validation 
  static String? passwordValidation(String? value) {

    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;


  }

  static String? confirmPasswordValidation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required.';
    }

    if (value != password) {
      return 'Passwords do not match.';
    }

    return null;
  }




}