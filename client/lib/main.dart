import 'package:flutter/material.dart';
import 'app.dart';
import 'package:flutter/services.dart';
import 'package:client_1/features/fitting_room/fitting_room.dart';
import 'features/authen/email_verify.dart';
import 'features/authen/login_screen.dart';
import 'features/authen/pass_reset.dart';
import 'features/authen/sigup_screen.dart';
import 'features/home/home.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white
    ),
    initialRoute: 'home',
    routes: {
      'home': (context) => Home(),
      '/': (context) => FittingRoom(),
      'login': (context) => LoginScreen(),
      'signup': (context) => SignUpScreen(),
    },
  ));
}


