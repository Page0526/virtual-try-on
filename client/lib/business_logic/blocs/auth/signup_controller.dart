
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/business_logic/blocs/auth/authen_repo.dart';
import 'package:myapp/business_logic/blocs/auth/user_repo.dart';
import 'package:myapp/business_logic/blocs/helper/loader_func.dart';
import 'package:myapp/business_logic/blocs/helper/network_controller.dart';
import 'package:myapp/business_logic/blocs/helper/snack_bar.dart';
import 'package:myapp/data/models/usermodel.dart';
import 'package:myapp/presentation/screens/auth/email_verify.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // controller for textfield
  final confirmPolicy = false.obs;
  final showpassword = true.obs;
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

  void signUp() async {
    try {
      // loading animation
      FullScreenLoader.showLoader(
          "Checking your information...", "assets/animations/loader.json");

      // chekck internet connectivity
      final isConnected = await NetworkController.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return; 
      }
    

      // form validation
      if (!formKey.currentState!.validate()) return;

      // policy checking
      if (!confirmPolicy.value) {
        // show warning dialog
        CusSnackBar.warningSnackBar(
            title: "Warning", message: "You must agree with our policy");
        return;
      }

      // register + save user data in firebase
      final authenUserr = await AuthenRepo.instance
          .writeEmailAndPassword(email.text.trim(), password.text.trim());
      final newuser = UserModel(
        id: authenUserr.user!.uid,
        firstname: firstname.text.trim(),
        lastname: lastname.text.trim(),
        username: username.text.trim(),
        emailorphone: email.text.trim(),
      );

      final userRepo = Get.put(UserRepo());
      await userRepo.saveUser(newuser);

      // show success dialog
      CusSnackBar.successSnackBar(
          title: "Success", message: "Sign up successfully");

      Get.to(() => VerifyEmailScreen(email: email.text.trim()));

    } catch (e) {
      // handle with error
      CusSnackBar.errorSnackBar(title: "Error", message: e.toString());
    } finally {
      // handle with error
        
      // FullScreenLoader.stopLoading();
    }
  }
}
