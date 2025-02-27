// lib/presentation/screens/wardrobe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/business_logic/blocs/clothing/clothing_bloc.dart';
import 'package:myapp/business_logic/blocs/clothing/clothing_event.dart';
import 'package:myapp/business_logic/blocs/clothing/clothing_state.dart';
import '../../data/services/clothing_service.dart';
import 'add_clothing_item_screen.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClothingBloc(ClothingService())..add(LoadClothingItems()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tủ Quần Áo Số'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddClothingItemScreen()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ClothingBloc, ClothingState>(
          builder: (context, state) {
            if (state is ClothingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ClothingLoaded) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return ListTile(
                    leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item.name),
                    subtitle: Text(item.type),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                      },
                    ),
                  );
                },
              );
            } else if (state is ClothingError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            return const Center(child: Text('Chưa có quần áo nào'));
          },
        ),
      ),
    );
  }
}