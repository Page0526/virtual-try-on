import 'package:client_1/features/home/controllers/home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client_1/common/widgets/quick_action.dart';
import 'package:client_1/utils/const/path.dart';
import 'package:client_1/utils/const/size.dart';
import 'package:client_1/utils/const/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickActionSlider extends StatelessWidget {
  const QuickActionSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(HomeController());

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 90,
              viewportFraction: 0.40,
            ),
            items: [
              QuickAction(
                  maintext: 'Virtual Try-on',
                  secondtext: 'Try new styles',
                  icon: Image.asset(CusPath.action1, height: 20, width: 20),
                  backgroundColor: Color(0xFF86A788),
                  // onPressed: () => Get.put(controller.updateQuickAction),
                ),
              QuickAction(
                  maintext: 'My Wardrobe',
                  secondtext: 'View collection',
                  icon: Image.asset(CusPath.action2, height: 20, width: 20),
                  backgroundColor: Color(0xFFFFFDEC),
                  // onPressed: () => Get.put(),
                ),
              QuickAction(
                  maintext: 'Style Match',
                  secondtext: 'Get suggestions',
                  icon: Image.asset(CusPath.action3, height: 20, width: 20),
                  backgroundColor: Color(0xFFFFE2E2),
                  // onPressed: () => Get.put(),
                ),
              QuickAction(
                  maintext: 'Favorites',
                  secondtext: 'Saved looks',
                  icon: Image.asset(CusPath.action4, height: 20, width: 20),
                  backgroundColor: Color(0xFFFFCFCF),
                  // onPressed: () => Get.put(),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
