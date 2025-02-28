import 'package:client_1/features/fitting_room/fitting_room.dart';
import 'package:client_1/features/home/home.dart';
import 'package:client_1/utils/const/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 60,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home, size: 20, color: CusColor.primaryTextColor), label: 'Home'),
              NavigationDestination(icon: Icon(Iconsax.shop, size: 20, color: CusColor.primaryTextColor), label: 'Shop'),
              NavigationDestination(icon: Icon(Iconsax.instagram, size: 20, color: CusColor.primaryTextColor), label: 'Try-on'),
              NavigationDestination(icon: Icon(Iconsax.heart, size: 20, color: CusColor.primaryTextColor), label: 'Liked'),
              NavigationDestination(icon: Icon(Iconsax.message_edit, size: 20, color: CusColor.primaryTextColor), label: 'Chatbot'),
            ]
          ),
      ),

      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const Home(), 
    Container(color: Colors.purple),
    const FittingRoom(),
    Container(color: Colors.yellow),
    Container(color: Colors.pink)
  ];
}