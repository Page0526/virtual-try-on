import 'package:client_1/features/authen/controller/authen_repo.dart';
import 'package:client_1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'feature/closet/screen/closet_detail_screen.dart';
import 'feature/closet/screen/closet_screen.dart';
import 'feature/closet/screen/clothes_detail_screen.dart';
import 'feature/fitting_room/screen/fitting_room.dart';
import 'feature/home/home_screen.dart';
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
