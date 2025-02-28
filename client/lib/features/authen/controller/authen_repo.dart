import 'package:client_1/features/authen/screen/email_verify.dart';
import 'package:client_1/features/authen/screen/login_screen.dart';
import 'package:client_1/features/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenRepo extends GetxController {
  static AuthenRepo get instance => Get.find();

  final storage = GetStorage();
  final _authen = FirebaseAuth.instance;


  @override
  void onReady() {
    FlutterNativeSplash.remove(); 
    screenRedirect();

  }

  // check if user is logged in
  screenRedirect() {
    final user = _authen.currentUser;
    if (user != null) {
      // check if user is verified
      user.reload();
      if (user.emailVerified == true) {
        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: _authen.currentUser!.email));
      }
    } else {
      Get.offAll(() => LoginScreen());
    }   
  }
  




  // write email and user name to storage
  Future<UserCredential> writeEmailAndPassword(
      String email, String password) async {
    try {
    UserCredential userCredential = await _authen.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    

    
    return userCredential;
    } catch (e) {
      throw "Error in here: $e";
    }
  } 


  // send email verification

  Future<void> sendEmailVerification() async {
    try {
      User? user = _authen.currentUser;
      await user!.sendEmailVerification();
    } catch (e) {
      throw "Error in here: $e";
    }
  }


  // logout function 
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      throw "Error in here: $e";
    }
    
  }



}
