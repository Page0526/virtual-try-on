import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenRepo extends GetxController {
  static AuthenRepo get instance => Get.find();

  final storage = GetStorage();
  final _authen = FirebaseAuth.instance;

  // write email and user name to storage
  Future<UserCredential> writeEmailAndPassword(
      String email, String password) async {
    try {
    UserCredential userCredential = await _authen.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    
    // Debugging output
    print("UserCredential: $userCredential");
    print("User: ${userCredential.user}");
    
    return userCredential;
    } catch (e) {
      throw "Error in here: $e";
    }
  } 


  


}
