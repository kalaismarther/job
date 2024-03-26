import 'package:shared_preferences/shared_preferences.dart';

// final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
// final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

final mobileNumberRegex = RegExp(r'^[0-9]{10}$');
late SharedPreferences pref;

class Validate {
  // static String? email(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please enter an email address';
  //   } else if (!emailRegex.hasMatch(value.trim())) {
  //     return 'Please enter a valid email address';
  //   }
  //   return null;
  // }
   static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? mobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an mobile number';
    } else if (!mobileNumberRegex.hasMatch(value)) {
      return 'Please enter a valid mobile number';
    }
    return null;
  }

  static sample() {
    return null;
  }
}
