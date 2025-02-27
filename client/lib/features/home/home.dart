import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client_1/utils/const/color.dart';
import 'package:client_1/utils/const/size.dart';

class Home extends StatefulWidget
{
  const Home({super.key});
  @override
  State<Home> createState() => _Home();
  
}

class _Home extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
    
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Outfits', style: TextStyle(fontSize: CusSize.fontSizeLg, fontWeight: FontWeight.w700)),
          // SizedBox(
          //   height: 425,
          //   child: FutureBuilder(
          //     future: fetchImageUrlsfromDB(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //       if (snapshot.hasError) {
          //         return Center(child: Text("Error ${snapshot.error}"));
          //       }
          //       if (snapshot.hasData || snapshot.data!.isBlank) {
          //         return const Center(child: Text("No images available"));
          //       }

          //       return ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         itemCount: snapshot.data!.length,
          //         itemBuilder: (context, index) {
          //           return Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 10),
          //             child: Container(
          //               width: 325,
          //               decoration: BoxDecoration(
          //                 color: Colors.black,
          //                 borderRadius: BorderRadius.circular(20)
          //               ),
          //               child: ClipRRect(
          //                 borderRadius: BorderRadius.circular(20),
          //                 child: Image.network(
          //                   snapshot.data![index],
          //                   fit: BoxFit.cover,
          //                   errorBuilder: (context, error, stackTract) => 
          //                     const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
          //                 ),
          //               ),
          //             ),
          //           );
          //         }
          //       );
          //     })
          // ),
          Text('Quick Actions', style: TextStyle(fontSize: CusSize.fontSizeLg,  fontWeight: FontWeight.w700)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickActions('Virtual Try-on', 'Try new styles', Color(0xFF86A788), Image.asset('assets/images/try-on.png', height: 20, width: 20), () {
                // TODO: add navigation to fitting room

              }),
              SizedBox(width: 10),
              _buildQuickActions('My Wardrobe', 'View collection', Color(0xFFFFFDEC), Image.asset('assets/images/wardrobe.png', height: 20, width: 20), () {
                // TODO: add navigation to wardrobe

              }),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickActions('Style Match', 'Get suggestions', Color(0xFFFFE2E2), Image.asset('assets/images/edit.png', height: 20, width: 20), () {
                // TODO: add navigation to chatbot

              }),
              SizedBox(width: 10),
              _buildQuickActions('Favorites', 'Saved looks', Color(0xFFFFCFCF), Image.asset('assets/images/favorites.png', height: 20, width: 20), () {
                // TODO: add navigation to favorites

              }),
            ],
          ),
        ],  
      ),
      bottomNavigationBar: _buildBottomNavBar()
    );
  }
}


Widget _buildQuickActions(String maintext, String secondtext, Color color, Widget icon, VoidCallback tryon) {
  return SizedBox(
    width: 140,
    height: 90,
    child: Material(
      color: Colors.transparent,
      shadowColor: Colors.grey.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(10),
      elevation: 3,
      child: InkWell(
        onTap: tryon,
        borderRadius: BorderRadius.circular(10),
        child: Material(  
          color: color,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2),
                icon,
                SizedBox(height: 10),
                Text(maintext, style: TextStyle(fontSize: CusSize.fontSizeMd, fontWeight: FontWeight.bold)),
                Text(secondtext, style: TextStyle(fontSize: CusSize.fontSizeSm, fontWeight: FontWeight.w300))
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

PreferredSizeWidget _buildAppBar() {
  return AppBar(
      backgroundColor: CusColor.barColor,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Image.asset('assets/images/user.png', height: 30, width: 30),
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
            Text('Hello Jessica', style: TextStyle(fontSize: 15, color: Color(0xFF242F9B))),
            SizedBox(height: 3),
            Text('What do you want to try on today?',  style: TextStyle(fontSize: CusSize.fontSizeSm, color: Color(0xFF242F9B)))
          ],
        ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_alert, color: CusColor.buttonPrimaryColor,),
          tooltip: 'Notifications',
          onPressed: () {
            // TODO: add notification
          }
        ),
        IconButton( 
          icon: Icon(Icons.help, color: CusColor.buttonPrimaryColor), 
          onPressed: () {
            // TODO: add help
          })
      ],
  );
}

Widget _buildBottomNavBar() {
  return Container(
    decoration: BoxDecoration(
        color: CusColor.barColor,
        boxShadow: [BoxShadow(
          color: Colors.grey.withValues(alpha: 0.35),
          blurRadius: 15,
          spreadRadius: 2,
          offset: Offset(0, -1),

        ),
        ],
    ),
    height: 60,
    child: BottomAppBar(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavItem('assets/images/home_button.png', () {
            // TODO: navigate to home

          }),
          SizedBox(width: 20),
          _buildNavItem('assets/images/shopping-cart.png', () {
            // TODO: navigate to shopping cart

          }),
          SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {
              // TODO: navigate to fitting room
            },
            backgroundColor: CusColor.buttonPrimaryColor,
            shape: CircleBorder(),
            elevation: 3,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          SizedBox(width: 20),
          _buildNavItem('assets/images/chatbot.png', () {
            // TODO: navigate to chatbot

          }),
          SizedBox(width: 20),
          _buildNavItem('assets/images/clothes-hanger.png', () {
            // TODO: navigate to wardrobe

          }),
        ]
        )
    ),
  );
}

Widget _buildNavItem(String assetPath, VoidCallback onTap) {
  return IconButton(
    icon: Image.asset(assetPath, height: 20, width: 20),
    onPressed: onTap,
  );
}