
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/common/widgets/quick_action.dart';
import 'package:myapp/features/fitting_room/screen/try_on_screen.dart';
import 'package:myapp/features/home/controllers/quick_action_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/features/routes/routes.dart';
import 'package:myapp/utils/const/path.dart';


class QuickActionSlider extends StatelessWidget {
  const QuickActionSlider({
    super.key,
  });

  
  @override
  Widget build(BuildContext context) {
    Get.put(QuickActionController());

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
                  onPressed: () => context.go(AppRoutes.fittingRoom),
                ),
              QuickAction(
                  maintext: 'My Wardrobe',
                  secondtext: 'View collection',
                  icon: Icon(Iconsax.search_normal),
                  backgroundColor: Color(0xFFA1E3F9),
                  onPressed: () => context.go(AppRoutes.closet),
                ),
              QuickAction(
                  maintext: 'Shopping',
                  secondtext: "Let's get dressed!",
                  icon: Icon(Iconsax.shop),
                  backgroundColor: Color(0xFFB3D8A8),
                  onPressed: () => context.go(AppRoutes.shop),
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
