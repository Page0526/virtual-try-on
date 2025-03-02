import 'package:myapp/features/authen/screen/login_screen.dart';
import 'package:myapp/utils/const/color.dart';
import 'package:myapp/utils/const/size.dart';
import 'package:myapp/utils/helper/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _navigateToVerificationScreen() {
    if (_emailController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(email: _emailController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final dark = Helper.isDarkMode(context);

    return Scaffold(
      backgroundColor: CusColor.accentColor, 
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(CusSize.defaultSpace),
          child: Card(
            color: dark ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),



            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(CusSize.defaultSpace),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [


                  Image.asset(
                    "assets/images/reset_password.png", // Thay bằng ảnh của bạn
                    height: 100,
                  ),
                  const SizedBox(height: CusSize.spaceBtwItems),


                  Text(
                    "Forgot your password?",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: CusSize.spaceBtwItems),



                  Text(
                    "Enter your Email or Mobile and we’ll help you reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: CusSize.spaceBtwItems),


                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Enter Email or Mobile Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),

                  const SizedBox(height: CusSize.spaceBtwItems),



                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToVerificationScreen,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text("Continue"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _verifyCode() {
    // Xử lý xác nhận mã (giả lập)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Verification Successful!")),
    );

    Get.to(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CusColor.accentColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(CusSize.defaultSpace),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            elevation: 5,

            child: Padding(
              padding: const EdgeInsets.all(CusSize.spaceBtwSections),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: CusColor.primaryColor, size: 60),

                  const SizedBox(height: CusSize.spaceBtwItems),
                  Text(
                    "Verification Required!",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: CusSize.spaceBtwItems),
                  Text(
                    "Enter the code sent to ${widget.email}",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: CusSize.defaultSpace),

                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: "Enter OTP",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),

                  const SizedBox(height: CusSize.defaultSpace),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verifyCode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text("Verify"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}