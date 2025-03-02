
import 'package:myapp/features/fitting_room/fitting_room.dart';
import 'package:myapp/features/home/screens/home.dart';
import 'package:myapp/features/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: Routes.home, page: () => const HomeScreen()),
    GetPage(name: Routes.fitting_room, page: () => const FittingRoom()),
    
  ];
}