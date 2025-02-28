import 'package:client_1/bingdings/general_binding.dart';
import 'package:client_1/features/authen/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: CusAppTheme.lightTheme,
      darkTheme: CusAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,

      initialBinding: GeneralBinding(), // binding
      // test
      home: const LoginScreen(),
    );
  }
}


// test thử  
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the second screen using a named route.
            print("Pressed!"); 
          },
          child: const Text('Launch screen'),
        ),
      ),
    );
  }
}
