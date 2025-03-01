

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CusSnackBar { 
    static void hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

    static void showSnackBar(String message, {Color? color}) {
        hideSnackBar();
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: color ?? Colors.black,
        ));
    } 


    static successSnackBar({required title, message = '', duration = 3}) {
        Get.snackbar(
            title, 
            message, 
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: duration),
            snackPosition: SnackPosition.BOTTOM,
            isDismissible: true, 
            shouldIconPulse: true,
            icon: Icon(Icons.check_circle, color: Colors.white),
            margin: EdgeInsets.all(10),
        );
    }

    static errorSnackBar({required title, message = '', duration = 3}) {
        Get.snackbar(
            title, 
            message, 
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: duration),
            snackPosition: SnackPosition.BOTTOM,
            isDismissible: true, 
            shouldIconPulse: true,
            icon: Icon(Icons.error, color: Colors.white),
            margin: EdgeInsets.all(10),
        );
    }

    static warningSnackBar({required title, message = '', duration = 3}) {
        Get.snackbar(
            title, 
            message, 
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: Duration(seconds: duration),
            snackPosition: SnackPosition.BOTTOM,
            isDismissible: true, 
            shouldIconPulse: true,
            icon: Icon(Icons.warning, color: Colors.white),
            margin: EdgeInsets.all(10),
        );
    }
    


}