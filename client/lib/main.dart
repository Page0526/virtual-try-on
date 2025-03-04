// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/closet/controller/closet_bloc.dart';
import 'package:myapp/features/closet/controller/closet_service.dart';
import 'package:myapp/features/closet/controller/clothing_bloc.dart';
import 'package:myapp/features/closet/controller/clothing_service.dart';
import 'package:myapp/features/closet/controller/outfit_bloc.dart';
import 'package:myapp/features/closet/controller/outfit_service.dart';
import 'package:myapp/features/routes/navigation_provider.dart';
import 'package:myapp/features/routes/router.dart';
import 'package:provider/provider.dart';
import 'utils/theme/theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => NavigationProvider()),
        Provider(create: (_) => ClosetService()),
        Provider(create: (_) => OutfitService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ClosetBloc(context.read<ClosetService>()),
          ),
          BlocProvider(
            create: (context) => ClothingBloc(
              ClothingService(context.read<ClosetService>()),
            ),
          ),
          BlocProvider(
            create: (context) => OutfitBloc(context.read<OutfitService>()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return MaterialApp.router(
      title: 'My App',
      theme: CusAppTheme.lightTheme,
      routerConfig: createRouter(navigationProvider),
    );
  }
}