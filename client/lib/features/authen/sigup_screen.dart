import 'package:client_1/features/authen/email_verify.dart';
import 'package:client_1/features/authen/login_screen.dart';
import 'package:client_1/utils/const/color.dart';
import 'package:client_1/utils/const/size.dart';
import 'package:client_1/utils/helper/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
                    Form(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "First name",
                                  labelStyle: TextStyle(
                                    fontSize:
                                        CusSize.fontSizeMd, // Smaller font size
                                    color: Colors.grey, // Faded color
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        CusSize.inputFieldRadius),
                                  ),
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                            ),
                            const SizedBox(width: CusSize.spaceBtwItems),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Last name",
                                  labelStyle: TextStyle(
                                    fontSize:
                                        CusSize.fontSizeMd, // Smaller font size
                                    color: Colors.grey, // Faded color
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        CusSize.inputFieldRadius),
                                  ),
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),

                    const SizedBox(height: CusSize.spaceBtwItems),
                    // username
                    TextFormField(
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
                    TextFormField(
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
                          )),
                    ),

                    const SizedBox(height: CusSize.spaceBtwItems),
                    // confirm password
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Confirm password",
                        labelStyle: TextStyle(
                          fontSize: CusSize.fontSizeMd, // Smaller font size
                          color: Colors.grey, // Faded color
                        ),
                      ),
                    ),

                    const SizedBox(height: CusSize.spaceBtwItems),

                    // term&condition
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text: "I agree to the ",
                                style: Theme.of(context).textTheme.bodySmall),
                            TextSpan(
                              text: "Terms of Service",
                              style: TextStyle(
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
                                color: dark
                                    ? const Color.fromARGB(255, 141, 141, 141)
                                    : CusColor.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ]),
                        )
                      ],
                    ),

                    const SizedBox(height: CusSize.spaceBtwItems),
                    // sign up button

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => VerifyEmailScreen()); 
                        },
                        child: Text("Create Account"),
                      ),
                    ),

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
