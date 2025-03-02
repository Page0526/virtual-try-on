
import 'package:myapp/utils/const/size.dart';
import 'package:flutter/material.dart';

/*
Class nay dung de dinh nghia cac style cho text trong app
*/

class CusTextTheme{
    CusTextTheme._();

    static TextTheme lightTextTheme = TextTheme(
      headlineLarge: const TextStyle().copyWith( fontSize: CusSize.fontSizeXxl , fontWeight: FontWeight.w700, color: Colors.black),
      headlineMedium: const TextStyle().copyWith( fontSize: CusSize.fontSizeXl, fontWeight: FontWeight.w700, color: Colors.black),
      headlineSmall: const TextStyle().copyWith( fontSize: CusSize.fontSizeLg, fontWeight: FontWeight.w700, color: Colors.black),

      bodyLarge: const TextStyle().copyWith( fontSize: CusSize.fontSizeMd, fontWeight: FontWeight.w400, color: Colors.black),
      bodyMedium: const TextStyle().copyWith( fontSize: CusSize.fontSizeSm, fontWeight: FontWeight.w400, color: Colors.black),
      bodySmall: const TextStyle().copyWith( fontSize: CusSize.fontSizeSm - 2.0, fontWeight: FontWeight.w400, color: Colors.black),

      titleLarge: const TextStyle().copyWith( fontSize: CusSize.fontSizeMd, fontWeight: FontWeight.w700, color: Colors.black),
      titleMedium: const TextStyle().copyWith( fontSize: CusSize.fontSizeSm, fontWeight: FontWeight.w700, color: Colors.black),
      titleSmall: const TextStyle().copyWith( fontSize: CusSize.fontSizeSm - 2.0, fontWeight: FontWeight.w700, color: Colors.black),

      labelLarge: const TextStyle().copyWith( fontSize: CusSize.fontSizeMd, fontWeight: FontWeight.w400, color: Colors.black),
      labelMedium: const TextStyle().copyWith( fontSize: CusSize.fontSizeSm, fontWeight: FontWeight.w400, color: Colors.black),

    );


    static TextTheme darkTextTheme = TextTheme(
      headlineLarge: const TextStyle().copyWith( fontSize: CusSize.fontSizeXxl, fontWeight: FontWeight.w700, color: Colors.white),
      headlineMedium: const TextStyle().copyWith( fontSize: CusSize.fontSizeXl, fontWeight: FontWeight.w700, color: Colors.white),
      headlineSmall: const TextStyle().copyWith( fontSize: CusSize.fontSizeLg, fontWeight: FontWeight.w700, color: Colors.white),

      bodyLarge: const TextStyle().copyWith( fontSize: CusSize.fontSizeMd, fontWeight: FontWeight.w400, color: Colors.white),
      bodyMedium: const TextStyle().copyWith( fontSize: CusSize.fontSizeSm, fontWeight: FontWeight.w400, color: Colors.white),
      bodySmall: const TextStyle().copyWith( fontSize: CusSize.fontSizeSm - 2.0, fontWeight: FontWeight.w400, color: Colors.white),

      titleLarge: const TextStyle().copyWith( fontSize: CusSize.fontSizeMd, fontWeight: FontWeight.w700, color: Colors.white),
      titleMedium: const TextStyle().copyWith( fontSize: CusSize.fontSizeSm, fontWeight: FontWeight.w700, color: Colors.white),
      titleSmall: const TextStyle().copyWith( fontSize: CusSize.fontSizeSm - 2.0, fontWeight: FontWeight.w700, color: Colors.white),
      labelLarge: const TextStyle().copyWith( fontSize: CusSize.fontSizeMd, fontWeight: FontWeight.w400, color: Colors.white),
      labelMedium: const TextStyle().copyWith( fontSize: CusSize.fontSizeSm, fontWeight: FontWeight.w400, color: Colors.white),
    );

}