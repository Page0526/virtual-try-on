import 'package:client_1/features/authen/controller/signup_controller.dart';
import 'package:client_1/features/authen/screen/login_screen.dart';
import 'package:client_1/utils/const/color.dart';
import 'package:client_1/utils/const/size.dart';
import 'package:client_1/utils/helper/helper_func.dart';
import 'package:client_1/utils/helper/validator_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Helper.isDarkMode(context);

    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(CusSize.defaultSpace),
                child: Column(
                  children: [
                    // header + title
                    Text("Create new account",
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: CusSize.spaceBtwItems),

                    //form
                    Signup_form(dark: dark),

                    const SizedBox(height: CusSize.spaceBtwItems),
                    // divider
                    LoginDivider(dark: dark),

                    const SizedBox(height: CusSize.spaceBtwSections),
                    // social button
                    SocialLogin(dark: dark),
                  ],
                ))));
  }
}

class Signup_form extends StatelessWidget {
  const Signup_form({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController()); 

    return Form(
      key : controller.formKey, 
      child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.firstname,
                validator: (value) => ValidatorFunc.emptyValidation(value),
                decoration: InputDecoration(
                  labelText: "First name",
                  labelStyle: TextStyle(
                    fontSize: CusSize.fontSizeMd, // Smaller font size
                    color: Colors.grey, // Faded color
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(CusSize.inputFieldRadius),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(width: CusSize.spaceBtwItems),
            Expanded(
              child: TextFormField(
                controller: controller.lastname,
                validator: (value) => ValidatorFunc.emptyValidation(value),
                decoration: InputDecoration(
                  labelText: "Last name",
                  labelStyle: TextStyle(
                    fontSize: CusSize.fontSizeMd, // Smaller font size
                    color: Colors.grey, // Faded color
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(CusSize.inputFieldRadius),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: CusSize.spaceBtwItems),
        // username
        TextFormField(
          controller : controller.username,
          validator : (value) => ValidatorFunc.emptyValidation(value),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: "Username",
            labelStyle: TextStyle(
              fontSize: CusSize.fontSizeMd, // Smaller font size
              color: Colors.grey, // Faded color
            ),
          ),
        ),

        const SizedBox(height: CusSize.spaceBtwItems),
        // email or phone numer
        TextFormField(
          controller : controller.email,
          validator : (value) => ValidatorFunc.emailOrPhoneValidation(value),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            labelText: "Email or phone number",
            labelStyle: TextStyle(
              fontSize: CusSize.fontSizeMd, // Smaller font size
              color: Colors.grey, // Faded color
            ),
          ),
        ),

        const SizedBox(height: CusSize.spaceBtwItems),
        // password
        Obx (() => TextFormField(
          controller : controller.password,
          obscureText: controller.showpassword.value,
          validator: (value) => ValidatorFunc.passwordValidation(value),
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: "Password",
              labelStyle: TextStyle(
                fontSize: CusSize.fontSizeMd, // Smaller font size
                color: Colors.grey, // Faded color
              ),
              suffixIcon: IconButton(
                icon: Icon(controller.showpassword.value ? Icons.visibility : Icons.visibility_off),
                onPressed: () =>  controller.showpassword.value = !controller.showpassword.value,
              )),
          ),
        ),


        const SizedBox(height: CusSize.spaceBtwItems),


        // confirm password
        Obx(() =>  TextFormField(
            controller : controller.confirmPassword,
            obscureText: controller.showConfirmPassword.value,
            validator: (value) => ValidatorFunc.confirmPasswordValidation(value, controller.password.text),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: "Confirm password",
              labelStyle: TextStyle(
                fontSize: CusSize.fontSizeMd, // Smaller font size
                color: Colors.grey, // Faded color
              ),
              suffixIcon: IconButton(
                icon: Icon(controller.showConfirmPassword.value ? Icons.visibility : Icons.visibility_off),
                onPressed: () => controller.showConfirmPassword.value = !controller.showConfirmPassword.value,
              ),
            ),
          ),
        ), 

        const SizedBox(height: CusSize.spaceBtwItems),

        // term&condition
        TermandCondition(dark: dark),

        const SizedBox(height: CusSize.spaceBtwItems),
        // sign up button

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => controller.signUp(),
            child: Text("Create Account"),
          ),
        ),
      ],
    ));
  }
}

class TermandCondition extends StatelessWidget {
  TermandCondition({
    super.key,
    required this.dark,
  });

  final bool dark;
  final controller = SignupController.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() => Checkbox(value: controller.confirmPolicy.value, onChanged: (value) {
            controller.confirmPolicy.value = !controller.confirmPolicy.value;
          }),
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
                text: "I agree to the ",
                style: Theme.of(context).textTheme.bodySmall),
            TextSpan(
              text: "Terms of Service",
              style: TextStyle(
                fontSize: 11,
                color: dark
                    ? const Color.fromARGB(255, 141, 141, 141)
                    : CusColor.primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              style: TextStyle( 
                fontSize: 11,
                color: dark
                    ? const Color.fromARGB(255, 141, 141, 141)
                    : CusColor.primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ]),
        )
      ],
    );
  }
}
