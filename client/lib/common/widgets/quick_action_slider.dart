import 'package:client_1/features/fitting_room/fitting_room.dart';
import 'package:client_1/features/home/controllers/home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client_1/common/widgets/quick_action.dart';
import 'package:client_1/features/home/controllers/quick_action_controller.dart';
import 'package:client_1/utils/const/path.dart';
import 'package:client_1/utils/const/size.dart';
import 'package:client_1/utils/const/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class QuickActionSlider extends StatelessWidget {
  const QuickActionSlider({
    super.key,
  });

  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuickActionController());

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
                  icon: Icon(Iconsax.instagram),
                  backgroundColor: Color(0xFFD1F8EF),
                  onPressed: () => Get.to(() => const FittingRoom())
                ),
              QuickAction(
                  maintext: 'My Wardrobe',
                  secondtext: 'View collection',
                  icon: Icon(Iconsax.search_normal),
                  backgroundColor: Color(0xFFA1E3F9),
                  // onPressed: () => Get.put(),
                ),
              QuickAction(
                  maintext: 'Style Match',
                  secondtext: 'Get suggestions',
                  icon: Icon(Iconsax.edit),
                  backgroundColor: Color(0xFFB3D8A8),
                  // onPressed: () => Get.put(),
                ), 
              QuickAction(
                  maintext: 'Favorites',
                  secondtext: 'Saved looks',
                  icon: Icon(Iconsax.heart),
                  backgroundColor: Color(0xFFA3D1C6),
                  // onPressed: () => Get.put(),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
