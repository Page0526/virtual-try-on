// lib/features/routes/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/common/widgets/navigation_bar.dart';
import 'package:myapp/features/assistant/screen/suggestion_screen.dart';
import 'package:myapp/features/closet/screen/add_clothing_item_screen.dart';
import 'package:myapp/features/closet/screen/closet_detail_screen.dart';
import 'package:myapp/features/closet/screen/closet_screen.dart';
import 'package:myapp/features/closet/screen/clothes_detail_screen.dart';
import 'package:myapp/features/closet/screen/outfit_detail_screen.dart';
import 'package:myapp/features/fitting_room/screen/result_screen.dart';
import 'package:myapp/features/fitting_room/screen/try_on_screen.dart';
import 'package:myapp/features/home/screens/home_screen.dart';
import 'package:myapp/features/profile/edit_profile.dart';
import 'package:myapp/features/profile/profile.dart';
import 'package:myapp/features/routes/navigation_provider.dart';
import 'package:myapp/features/routes/routes.dart';
import 'package:myapp/features/setting/settings.dart';
import 'package:myapp/features/shop/screen/cart_screen.dart';
import 'package:myapp/features/shop/screen/item_detail_screen.dart';
import 'package:myapp/features/shop/screen/shop_screen.dart';

GoRouter createRouter(NavigationProvider navigationProvider) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(
            navigationShell: navigationShell,
            navigationProvider: navigationProvider,
          );
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 1: Closet
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.closet,
                builder: (context, state) => const ClosetScreen(),
                routes: [
                  GoRoute(
                    path: 'add-clothing-item',
                    builder: (context, state) => const AddClothingItemScreen(),
                  ),
                  GoRoute(
                    path: ':closetId',
                    builder: (context, state) => ClosetDetailScreen(
                      closetId: state.pathParameters['closetId']!,
                      closetName: state.uri.queryParameters['closetName'] ?? 'Unknown',
                    ),
                  ),
                  GoRoute(
                    path: 'outfit/:outfitId',
                    builder: (context, state) => OutfitDetailScreen(
                      outfitId: state.pathParameters['outfitId']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: AppRoutes.clothes,
                builder: (context, state) {
                  final itemImage = state.uri.queryParameters['itemImage'] ?? '';
                  final brand = state.uri.queryParameters['brand'] ?? '';
                  final date = state.uri.queryParameters['date'] ?? '';
                  final type = state.uri.queryParameters['type'] ?? '';
                  return ClothesDetailScreen(
                    itemImage: itemImage,
                    brand: brand,
                    date: date,
                    type: type,
                  );
                },
              ),
            ],
          ),
          // Branch 2: Try On (Fitting Room)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.fittingRoom,
                builder: (context, state) => const FittingRoom(),
                routes: [
                  GoRoute(
                    path: 'result',
                    builder: (context, state) {
                      final resultImageBytes = state.extra as List<int>;
                      return ResultScreen(resultImageBytes: resultImageBytes);
                    },
                  ),
                ],
              ),
              GoRoute(
                    path: '/suggestion',
                    builder: (context, state) {
                      final resultImageBytes = state.extra as List<int>;
                      return SuggestionScreen(resultImageBytes: resultImageBytes);
                    },
                  ),
            ],
          ),
          // Branch 3: Shop
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.shop,
                builder: (context, state) => const Shop(),
              ),
              GoRoute(
                path: AppRoutes.item,
                builder: (context, state) {
                  final itemImage = state.uri.queryParameters['itemImage'] ?? '';
                  final brand = state.uri.queryParameters['brand'] ?? '';
                  final date = state.uri.queryParameters['date'] ?? '';
                  final type = state.uri.queryParameters['type'] ?? '';
                  return ShopClothesDetailScreen(
                    itemImage: itemImage,
                    brand: brand,
                    date: date,
                    type: type,
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.cart,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          // Branch 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
              GoRoute(
                path: AppRoutes.editProfile,
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final NavigationProvider navigationProvider;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
    required this.navigationProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onItemTapped: (index) {
          navigationProvider.setIndex(index);
          navigationShell.goBranch(index);
        },
      ),
    );
  }
}