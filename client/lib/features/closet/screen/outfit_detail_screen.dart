// lib/features/closet/screen/outfit_detail_screen.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/closet/model/outfit.dart';
import '/features/closet/controller/outfit_bloc.dart';
import '/features/closet/controller/outfit_state.dart';

class OutfitDetailScreen extends StatelessWidget {
  final String outfitId;

  const OutfitDetailScreen({super.key, required this.outfitId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết Outfit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<OutfitBloc, OutfitState>(
        builder: (context, state) {
          if (state is OutfitLoaded) {
            final outfit = state.outfits.firstWhere(
              (o) => o.id == outfitId,
              orElse: () => Outfit(id: '', name: 'Không tìm thấy', categoryId: ''),
            );
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (outfit.imageBytes != null)
                    SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Image.memory(
                        Uint8List.fromList(outfit.imageBytes!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 100);
                        },
                      ),
                    )
                  else
                    const Icon(Icons.image, size: 100),
                  const SizedBox(height: 20),
                  Text(
                    outfit.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Danh mục: ${outfit.categoryId}'),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}