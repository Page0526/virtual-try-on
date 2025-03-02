import 'package:myapp/features/fashion_agent/agent_screen.dart';
import 'package:myapp/features/fitting_room/fitting_room.dart';
import 'package:myapp/features/home/screens/home.dart';
import 'package:myapp/utils/const/color.dart';
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
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
              TextStyle(color: CusColor.primaryTextColor, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
              height: 60,
              elevation: 0,
              backgroundColor: CusColor.barColor,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) => controller.selectedIndex.value = index,
              destinations: const [
                NavigationDestination(icon: Icon(Iconsax.home, size: 20, color: CusColor.buttonPrimaryColor), label: 'Home'),
                NavigationDestination(icon: Icon(Iconsax.shop, size: 20, color: CusColor.buttonPrimaryColor), label: 'Shop'),
                NavigationDestination(icon: Icon(Iconsax.instagram, size: 20, color: CusColor.buttonPrimaryColor), label: 'Try-on'),
                NavigationDestination(icon: Icon(Iconsax.heart, size: 20, color: CusColor.buttonPrimaryColor), label: 'Liked'),
                NavigationDestination(icon: Icon(Iconsax.message_edit, size: 20, color: CusColor.buttonPrimaryColor), label: 'Chatbot'),
              ]
            ),
        ),
      ),

      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(), 
    Container(color: Colors.purple),
    const FittingRoom(),
    Container(color: Colors.yellow),
    ChatScreen(),
  ];
}