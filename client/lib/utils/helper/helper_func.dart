

import 'package:flutter/material.dart';

class Helper {

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;

  }



}