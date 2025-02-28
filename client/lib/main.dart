import 'package:client_1/features/authen/controller/authen_repo.dart';
import 'package:client_1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'package:flutter/services.dart';
import 'package:client_1/features/fitting_room/fitting_room.dart';
import 'package:client_1/features/authen/screen/email_verify.dart';
import 'package:client_1/features/authen/screen/login_screen.dart';
import 'package:client_1/features/authen/screen/pass_reset.dart';
import 'package:client_1/features/authen/screen/signup_screen.dart';
import 'features/home/home.dart';

Future<void> main() async {

  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();

  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then( (FirebaseApp value) => Get.put(AuthenRepo()));



  runApp(const MyApp());
}


