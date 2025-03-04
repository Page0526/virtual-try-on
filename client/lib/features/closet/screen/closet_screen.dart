// lib/features/closet/screen/closet_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/closet/controller/closet_bloc.dart';
import 'package:myapp/features/closet/controller/closet_event.dart';
import 'package:myapp/features/closet/controller/outfit_bloc.dart';
import 'package:myapp/features/closet/controller/outfit_event.dart';
import 'package:myapp/features/closet/screen/closet_tab_screen.dart';
import 'package:myapp/features/closet/screen/outfit_tab_screen.dart';
import 'package:myapp/features/closet/screen/packing_tab_screen.dart';
import 'package:myapp/features/routes/navigation_provider.dart';
import 'package:myapp/features/routes/routes.dart';
import 'package:provider/provider.dart';

class ClosetScreen extends StatefulWidget {
  const ClosetScreen({super.key});

  @override
  State<ClosetScreen> createState() => _ClosetScreenState();
}

class _ClosetScreenState extends State<ClosetScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<ClosetBloc>().add(LoadClosets());
    context.read<OutfitBloc>().add(LoadOutfitCategories());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tủ Quần Áo Số'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Provider.of<NavigationProvider>(context, listen: false).setIndex(0);
            context.go(AppRoutes.home);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Provider.of<NavigationProvider>(context, listen: false).setIndex(4);
              context.go(AppRoutes.profile);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Closet'),
            Tab(text: 'Outfit'),
            Tab(text: 'Packing'),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ClosetTabScreen(),
          OutfitTabScreen(),
          PackingTabScreen(),
        ],
      ),
    );
  }
}