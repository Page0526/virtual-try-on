import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/presentation/screens/closet/closet_detail_screen.dart';
import 'package:myapp/presentation/screens/closet/closet_screen.dart';
import 'package:myapp/presentation/screens/closet/clothes_detail_screen.dart';
import 'package:myapp/presentation/screens/fitting_room/fitting_room.dart';
import 'package:myapp/presentation/screens/home/home_screen.dart';

import 'shared/themes/app_theme.dart';

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