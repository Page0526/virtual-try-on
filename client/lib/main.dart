import 'package:flutter/material.dart';
import 'app.dart';
import 'package:flutter/services.dart';
import 'package:client_1/pages/fitting_room.dart';

void main() {

  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => FittingRoom(),
    },
  ));
}


