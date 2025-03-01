import 'package:client_1/features/home/controllers/home_controller.dart';
import 'package:client_1/common/widgets/rounded_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client_1/common/widgets/circular_container.dart';
import 'package:client_1/utils/const/size.dart';
import 'package:client_1/utils/const/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentOutfitSlider extends StatelessWidget {
  RecentOutfitSlider({
    super.key,
    required this.banners,
  });

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 260, 
              viewportFraction: 0.55,
              // enlargeCenterPage: true,
              onPageChanged: (index, _) => controller.updatePageIndicator(index)
            ),
            items: banners.map((url) => RoundedImg(imageURL: url)).toList(), 
          ),
          const SizedBox(height: CusSize.defaultSpace),
          Center(
            child: Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < 3; i++)
                    CircularContainer(
                      width: 15,
                      height: 4,
                      backgroundColor: controller.carousalCurrentIndex.value == i ? CusColor.buttonPrimaryColor : Colors.grey,
                    margin: const EdgeInsets.only(right: 10),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}