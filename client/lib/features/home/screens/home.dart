import 'package:carousel_slider/carousel_slider.dart';
import 'package:myapp/common/widgets/quick_action_slider.dart';
import 'package:myapp/utils/const/path.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils/const/color.dart';
import 'package:myapp/utils/const/size.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/common/widgets/recent_outfit_slider.dart';

class HomeScreen extends StatefulWidget
{
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreen();
  
}

class _HomeScreen extends State<HomeScreen> {
    
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                child: Text('Recent Outfits', style: TextStyle(fontSize: CusSize.fontSizeLg, fontWeight: FontWeight.w700, color: CusColor.primaryTextColor)),
              ),
            ],
          ),
          RecentOutfitSlider(banners: [CusPath.banner1, CusPath.banner2, CusPath.banner3]),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Quick Actions', style: TextStyle(fontSize: CusSize.fontSizeLg,  fontWeight: FontWeight.w700, color: CusColor.primaryTextColor)),
              ),
            ],
          ),
          QuickActionSlider(),
        ],  
      ),
    );
  }
}

Future<List<String>> fetchImageUrlsfromDB() async {
  await Future.delayed(Duration(seconds: 2));

  return [

  ];
}


PreferredSizeWidget _buildAppBar() {
  return AppBar(
      backgroundColor: CusColor.barColor,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Iconsax.profile_circle, size: 30, color: CusColor.buttonPrimaryColor),
            onPressed: () {
              // TODO: add profile screen
            },
          );
        },
      ),
      titleSpacing: 2,
      title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hello Jessica', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: CusColor.primaryTextColor)),
            SizedBox(height: 3),
            Text('What do you want to try on today?',  style: TextStyle(fontSize: CusSize.fontSizeSm, fontWeight: FontWeight.w400, color: CusColor.primaryTextColor))
          ],
        ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.notification, color: CusColor.buttonPrimaryColor),
          tooltip: 'Notifications',
          onPressed: () {
            // TODO: add notification
          }
        ),
        IconButton( 
          icon: Icon(Iconsax.message_question, color: CusColor.buttonPrimaryColor), 
          onPressed: () {
            // TODO: add help
          })
      ],
  );
}
