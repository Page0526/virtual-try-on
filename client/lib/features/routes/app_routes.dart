
import 'package:client_1/features/fitting_room/fitting_room.dart';
import 'package:client_1/features/home/screens/home_screen.dart';
import 'package:client_1/features/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: Routes.home, page: () => const HomeScreen()),
    GetPage(name: Routes.fitting_room, page: () => const FittingRoom()),
    
  ];
}