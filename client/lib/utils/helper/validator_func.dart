
class ValidatorFunc {
  // empty validation 
  static String? emptyValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }

    return null;
  }




  // check email validation 
  static String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
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


  // phonenumber validation
  static String? phoneNumberValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // Regular expression for phone number validation
    final phoneRegExp = RegExp(r'^[0-9]{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number.';
    }

    return null;
  }
}