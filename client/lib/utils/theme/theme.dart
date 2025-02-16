import 'package:flutter/material.dart';
import 'text_theme.dart'; 
import 'component_theme.dart';

/* 
Class nay dung de dinh nghia 2 loai theme cho app (light + dark) 
*/

class CusAppTheme {
  CusAppTheme._();

  static ThemeData lightTheme = ThemeData(

      useMaterial3: true, // enable Material 3
      fontFamily: 'Roboto',
      primaryColor: const Color.fromARGB(255, 1, 173, 173),
      scaffoldBackgroundColor: const Color(0xFFF1F2F6),
      brightness: Brightness.light,

      // setting mau + kich thuoc cho text
      textTheme: CusTextTheme.lightTextTheme, 

      // button doi theme 
      elevatedButtonTheme: CusButtonTheme.lightbutton,  

      appBarTheme: CusAppBarTheme.lightAppBar, 

      bottomSheetTheme: CusBottomSheetTheme.lightBottomSheet, 

      checkboxTheme: CusCheckboxTheme.lightCheckboxTheme, 

      chipTheme: CusChipTheme.lightChipTheme, 

      outlinedButtonTheme: CusOutlineButtonTheme.lightOutlinedButtonTheme, 

      inputDecorationTheme: CusTextFormFieldTheme.lightInputDecorationTheme
  
      );

  static ThemeData darkTheme = ThemeData(

      useMaterial3: true, // enable Material 3
      fontFamily: 'Roboto',
      primaryColor: const Color.fromARGB(255, 1, 173, 173),
      scaffoldBackgroundColor: const Color(0xFF121212),
      brightness: Brightness.dark,

      // setting mau + kich thuoc cho text
      textTheme: CusTextTheme.darkTextTheme, 

      // button doi theme
      elevatedButtonTheme: CusButtonTheme.darkbutton,


      appBarTheme: CusAppBarTheme.darkAppBar, 

      bottomSheetTheme: CusBottomSheetTheme.darkBottomSheet,

      checkboxTheme: CusCheckboxTheme.darkCheckboxTheme,

      chipTheme: CusChipTheme.darkChipTheme,

      outlinedButtonTheme: CusOutlineButtonTheme.darkOutlinedButtonTheme,

      inputDecorationTheme: CusTextFormFieldTheme.darkInputDecorationTheme
      );
}
