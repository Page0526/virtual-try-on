import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/fitting_room/screen/try_on_screen.dart';
import 'package:myapp/features/shop/screen/cart_screen.dart';
import 'package:myapp/features/shop/screen/item_detail_screen.dart';
import 'package:myapp/features/shop/screen/shop_screen.dart';
import 'features/closet/screen/closet_detail_screen.dart';
import 'features/closet/screen/closet_screen.dart';
import 'features/closet/screen/clothes_detail_screen.dart';

import 'features/home/home_screen.dart';
import 'utils/themes/app_theme.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/closet',
        builder: (context, state) => const ClosetScreen(),
      ),
      GoRoute(
        path: '/shop',
        builder: (context, state) => const Shop(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/fitting_room',
        builder: (context, state) => const FittingRoom(),
      ),
      GoRoute(
        path: '/closet/:closetName',
        builder: (context, state) => ClosetDetailScreen(
          closetName: state.pathParameters['closetName']!,
        ),
      ),
      GoRoute(
        path: '/clothes',
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
      GoRoute(
        path: '/item',
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
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}