import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/usermodel.dart';


class UserRepo extends GetxController {
  static UserRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }
}
