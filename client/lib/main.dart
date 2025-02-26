import 'package:client_1/features/authen/controller/authen_repo.dart';
import 'package:client_1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';



Future<void> main() async {

  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then( (FirebaseApp value) => Get.put(AuthenRepo()));



  runApp(const MyApp());
}



