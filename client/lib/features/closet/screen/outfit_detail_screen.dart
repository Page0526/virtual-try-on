// lib/features/closet/screen/outfit_detail_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/closet/controller/outfit_bloc.dart';
import 'package:myapp/features/closet/controller/outfit_event.dart';
import 'package:myapp/features/closet/controller/outfit_state.dart';
import 'package:myapp/features/closet/model/item.dart';
import 'package:myapp/features/closet/model/outfit.dart';

class OutfitDetailScreen extends StatefulWidget {
  final String outfitId;

  const OutfitDetailScreen({super.key, required this.outfitId});

  @override
  State<OutfitDetailScreen> createState() => _OutfitDetailScreenState();
}

class _OutfitDetailScreenState extends State<OutfitDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OutfitBloc>().add(LoadOutfitsByCategory('')); // Load lại để lấy outfit
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutfitBloc, OutfitState>(
      builder: (context, state) {
        if (state is OutfitsByCategoryLoaded) {
          final outfit = state.outfits.firstWhere(
            (outfit) => outfit.id == widget.outfitId,
            orElse: () => const Outfit(id: '', name: 'Unknown', categoryId: ''),
          );
          if (outfit.id.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Outfit không tồn tại')),
            );
          }
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => context.go('/closet'),
              ),
              title: Text(outfit.name),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder cho hình ảnh người mặc Outfit
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Items in this Outfit:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: outfit.items.length,
                      itemBuilder: (context, index) {
                        final item = outfit.items[index];
                        return _buildItemCard(item, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildItemCard(Item item, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          context.push(
            '/clothes?itemImage=${Uri.encodeComponent(item.imageUrl)}&brand=${Uri.encodeComponent(item.brand ?? 'No Brand')}&date=${Uri.encodeComponent(item.date ?? '')}&type=${Uri.encodeComponent(item.type)}',
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                File(item.imageUrl),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 100);
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.type,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      item.brand ?? 'No Brand',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.date ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}