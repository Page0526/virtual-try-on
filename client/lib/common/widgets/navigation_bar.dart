import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/utils/const/graphic/color.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Iconsax.home, size: 20, color: CusColor.buttonPrimaryColor), label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.heart, size: 20, color: CusColor.buttonPrimaryColor), label: 'Closet'
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.instagram, size: 20, color: CusColor.buttonPrimaryColor), label: 'Try-on'
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.shop, size: 20, color: CusColor.buttonPrimaryColor), label: 'Shop'
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.message_edit, size: 20, color: CusColor.buttonPrimaryColor), label: 'AIStylist'
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.profile_add, size: 20, color: CusColor.buttonPrimaryColor), label: 'Profile'
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black87,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: CusColor.barColor,
    );
  }
}