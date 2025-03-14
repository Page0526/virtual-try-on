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
import 'package:myapp/utils/const/graphic/color.dart';
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
    context.read<OutfitBloc>().add(LoadOutfits());
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
        backgroundColor: CusColor.barColor,
        title: const Text('Tủ Quần Áo Số'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
        elevation: 8,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.black,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          tabs: const [
            Tab(text: 'Tủ Đồ'),
            Tab(text: 'Outfit'),
            Tab(text: 'Đóng Gói'),
          ],   
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