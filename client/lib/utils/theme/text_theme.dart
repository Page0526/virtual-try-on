
import 'package:flutter/material.dart';

/*
Class nay dung de dinh nghia cac style cho text trong app
*/

class CusTextTheme{
    CusTextTheme._();

    static TextTheme lightTextTheme = TextTheme(
      headlineLarge: const TextStyle().copyWith( fontSize: 32, fontWeight: FontWeight.w700, color: Colors.black),
      headlineMedium: const TextStyle().copyWith( fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
      headlineSmall: const TextStyle().copyWith( fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),

      bodyLarge: const TextStyle().copyWith( fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
      bodyMedium: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
      bodySmall: const TextStyle().copyWith( fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),

      titleLarge: const TextStyle().copyWith( fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
      titleMedium: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black),
      titleSmall: const TextStyle().copyWith( fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),

      labelLarge: const TextStyle().copyWith( fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
      labelMedium: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),

    );


    static TextTheme darkTextTheme = TextTheme(
      headlineLarge: const TextStyle().copyWith( fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
      headlineMedium: const TextStyle().copyWith( fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
      headlineSmall: const TextStyle().copyWith( fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),

      bodyLarge: const TextStyle().copyWith( fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      bodyMedium: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
      bodySmall: const TextStyle().copyWith( fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),

      titleLarge: const TextStyle().copyWith( fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
      titleMedium: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
      titleSmall: const TextStyle().copyWith( fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),

      labelLarge: const TextStyle().copyWith( fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
      labelMedium: const TextStyle().copyWith( fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
    );

}