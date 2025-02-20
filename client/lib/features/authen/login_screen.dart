import 'package:client_1/common/style/spacing.dart';
import 'package:client_1/features/authen/sigup_screen.dart';
import 'package:client_1/utils/const/size.dart';
import 'package:client_1/utils/helper/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Helper.isDarkMode(context);


    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding : SpacingStyle.padding, 
          child: Column(
            children: [
              // header (logo + title + description) 
              LoginHeader(dark: dark),

              // form (email + password) 
              LoginForm(), 

              // forgot password + remember me 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row (children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    Text("Remember me"),
                  ],), 

                  TextButton(onPressed: () {}, child: Text("Forgot password?")),
                ],
              ),

              const SizedBox(height: CusSize.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {}, 
                  child: Text("Login"),
                ),
              ),
              // login button 
              
              // register button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.to(() => SignUpScreen()), 
                  child: Text("Create new account"),
                ),
              ),
              const SizedBox(height: CusSize.spaceBtwItems),



              // divider
              LoginDivider(dark: dark), 

              const SizedBox(height: CusSize.spaceBtwSections),

              // social login
              SocialLogin(dark: dark) 
             
            ],
          )
        )
      ),
    );
  }
}

class LoginDivider extends StatelessWidget {
  const LoginDivider({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Divider( color : dark ? const Color.fromARGB(255, 196, 195, 195) : const Color.fromARGB(255, 73, 73, 73), thickness: 1,indent: 60, endIndent: 10)),
        Text("Or continue with", style: Theme.of(context).textTheme.labelMedium),
        Flexible(child: Divider( color : dark ? const Color.fromARGB(255, 196, 195, 195) : const Color.fromARGB(255, 73, 73, 73), thickness: 1, indent: 10, endIndent: 60,)), 
      ],
    );
  }
}

class SocialLogin extends StatelessWidget {
  const SocialLogin({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: dark ? const Color.fromARGB(255, 196, 195, 195) : const Color.fromARGB(255, 73, 73, 73)),
            borderRadius: BorderRadius.circular(CusSize.buttonRadius),
          ),
          child: IconButton(
            onPressed: () {}, 
            icon: Image.asset('assets/images/google_logo.png', width: CusSize.iconMd, height: CusSize.iconMd),
          ),
        ), 
        const SizedBox(width: CusSize.spaceBtwItems),
    
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: dark ? const Color.fromARGB(255, 196, 195, 195) : const Color.fromARGB(255, 73, 73, 73)),
            borderRadius: BorderRadius.circular(CusSize.buttonRadius),
          ),
          child: IconButton(
            onPressed: () {}, 
            icon: Image.asset('assets/images/facebook_icon.png', width: CusSize.iconMd, height: CusSize.iconMd),
          ),
        )
      
      ],
    
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child:  Padding(
        padding: const EdgeInsets.symmetric(vertical: CusSize.spaceBtwInputFields),
        child: Column(
          children: [
            // email 
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "Email",
                labelStyle: TextStyle(
                  fontSize: CusSize.fontSizeMd, // Smaller font size
                  color: Colors.grey, // Faded color
                  ),
              ),
            ), 
            const SizedBox(height: CusSize.spaceBtwInputFields),
        
            // password 
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: "Password",
                labelStyle: TextStyle(
                  fontSize: CusSize.fontSizeMd, // Smaller font size
                  color: Colors.grey, // Faded color
                  ),
                suffixIcon: IconButton(
                icon: Icon(Icons.visibility_off),
                onPressed: () {
                  // Add functionality to toggle password visibility
                },
                ),
              ),
            ), 
            const SizedBox(height: CusSize.spaceBtwInputFields),
          ],
        ),
      )
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        // logo 
        Image(
        height: 150,
        image: AssetImage(dark ? 'assets/images/dark_logo.png' : 'assets/images/light_logo.jpg'),
        ), 
    
        // title and subtitle 
        Text("Welcome back!", style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: CusSize.sm),
        Text("Sign in to continue", style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}