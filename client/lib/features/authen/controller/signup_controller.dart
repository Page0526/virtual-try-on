import 'package:client_1/utils/const/path.dart';
import 'package:client_1/utils/helper/loader_func.dart';
import 'package:client_1/utils/helper/network_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // controller for textfield
  final confirmPolicy = false.obs;
  final showpassword  = true.obs;
  final showConfirmPassword = true.obs;
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
      // loading animation 
      FullScreenLoader.showLoader("Checking your information...", CusPath.animationLoader);


      // chekck internet connectivity
      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) return;
      

      // form validation
      if (!formKey.currentState!.validate()) return;

      // term checking
      if (!confirmPolicy.value) {
        // show warning dialog


        
        return;
      }



      // register + save user data in firebase

      // show success dialog
    } catch (e) {
      // handle with error
    } finally {
      // handle with error
      FullScreenLoader.hideLoader(); 

    }
  }
}
