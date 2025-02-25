import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // variable
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final username = TextEditingController();
  final phone = TextEditingController();
  final lastname = TextEditingController();
  final firstname = TextEditingController(); 

  // tham chieu toi mot form 
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  Future<void> signUp() async {
    try {
      // loading data

      // chekck internet connectivity

      // form validation

      // term checking

      // register + save user data in firebase

      // show success dialog
    } catch (e) {
      // handle with error
    } finally {
      // handle with error
    }
  }
}
