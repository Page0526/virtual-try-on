import 'dart:async';
import '../screen/email_verify.dart';
import 'authen_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../utils/helper/snack_bar.dart';


class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();


  // send email verification every verify email appear 
  @override
  void onInit() {
    super.onInit();
    sendEmailVerification();

  }


  void sendEmailVerification () async  {
    try {
      // send email verification
      await AuthenRepo.instance.sendEmailVerification();
      CusSnackBar.successSnackBar(title: "Email sent", message: "Please check your email to verify your account");
    } catch (e) {
      // show error dialog
      CusSnackBar.errorSnackBar(title: "Error", message: "Error in here: $e");
    }
  }



  AutoRedirectTime() async { 
    Timer.periodic (Duration(seconds: 5), (timer) async {
      // check if user is verified
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified == true) {
        // if user is verified, show success dialog
        timer.cancel();
        Get.off( () => VerifiedScreen());
      }



    });

  }

  // manually check email verification 
  manuallyEmailVerification() async { 
    final user = FirebaseAuth.instance.currentUser;
    if ( user?.emailVerified == true) {
      Get.off( () => VerifiedScreen());
    } else {
      CusSnackBar.errorSnackBar(title: "Error", message: "Email is not verified yet");
    }



  }


}