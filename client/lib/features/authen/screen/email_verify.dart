import 'package:client_1/features/authen/screen/login_screen.dart';
import 'package:client_1/utils/const/color.dart';
import 'package:client_1/utils/const/size.dart';
import 'package:client_1/utils/helper/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// import 'verified_screen.dart'; // Import màn hình xác nhận thành công

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController otpController = TextEditingController();
    
    return Scaffold(
      appBar : AppBar(), 
      body: Padding(
        padding: const EdgeInsets.all(CusSize.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            // image 
            Image.asset("assets/images/email-verification.png", height: 150),
            const SizedBox(height: CusSize.spaceBtwItems),

            // Tiêu đề
            Text(
              "Verify your email",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: CusSize.spaceBtwItems / 2 ),

            // Mô tả
            Text(
              "Please enter the 4-digit code sent to your e-mail",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: CusSize.spaceBtwItems),

            // Trường nhập OTP
            PinCodeTextField(
              length: 4,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(CusSize.buttonRadius),
                fieldHeight: 50,
                fieldWidth: 50,
                activeColor: CusColor.primaryColor,
                selectedColor: CusColor.primaryColor,
                inactiveColor: Colors.grey,
              ),
              controller: otpController,
              keyboardType: TextInputType.number,
              onChanged: (value) {},
              appContext: context,
            ),

            const SizedBox(height: CusSize.spaceBtwItems),

            // Resend Code
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                   // Chuyển sang màn hình xác nhận thành công
                },
                child: const Text("Resend code"),
              ),
            ),

            // Nút Confirm
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const VerifiedScreen()); // Chuyển sang màn hình xác nhận thành công
                },
                child: const Text("Confirm"),
              ),
            ),

            const SizedBox(height: CusSize.spaceBtwItems),

          ],
        ),
      ),
    );
  }
}


class VerifiedScreen extends StatelessWidget {
  const VerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Helper.isDarkMode(context);
    return Scaffold(
      backgroundColor: CusColor.accentColor,
      body: Center(


        child: Container(
          margin: const EdgeInsets.all(CusSize.defaultSpace),
          padding: const EdgeInsets.all(CusSize.defaultSpace),
          decoration: BoxDecoration(
            color: dark ? Colors.black :  Colors.white,
            borderRadius: BorderRadius.circular(CusSize.borderRadiusLg),
          ),


          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon xác nhận thành công
              const Icon(Icons.check_circle, color: CusColor.primaryColor, size: 80),
              const SizedBox(height: CusSize.spaceBtwItems),

              // Tiêu đề
              Text(
                "Verified!",
                style: Theme.of(context).textTheme.headlineLarge,
              ),


              const SizedBox(height: CusSize.spaceBtwItems),

              // Nội dung xác nhận
              Text(
                "Yahoo! You have successfully verified the account.",
                textAlign: TextAlign.center,
                style: TextStyle(color: dark ? const Color.fromARGB(255, 189, 189, 189): Colors.grey[700]),
              ),

              const SizedBox(height: CusSize.spaceBtwItems),

              // Nút điều hướng đến Dashboard
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => LoginScreen()); // Chuyển đến trang Dashboard (cần định nghĩa route)
                  },
                  child: const Text("Go to Dashboard", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}