import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '/features/closet/controller/outfit_bloc.dart';
import '/features/closet/controller/outfit_state.dart';
import '/features/closet/model/outfit.dart';

class OutfitTabScreen extends StatelessWidget {
  const OutfitTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutfitBloc, OutfitState>(
      builder: (context, state) {
        if (state is OutfitLoading) {
          return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
        } else if (state is OutfitLoaded) {
          final outfits = state.outfits;
          if (outfits.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có outfit nào',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: outfits.length,
            itemBuilder: (context, index) {
              final outfit = outfits[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: outfit.imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            Uint8List.fromList(outfit.imageBytes!),
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                            ),
                          ),
                        )
                      : Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.image, size: 30, color: Colors.grey),
                        ),
                  title: Text(
                    outfit.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  subtitle: Text(
                    outfit.categoryId,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  onTap: () {
                    context.push('/closet/outfit/${outfit.id}');
                  },
                ),
              );
            },
          );
        } else if (state is OutfitError) {
          return Center(
            child: Text(
              'Lỗi: ${state.message}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }
        return const Center(
          child: Text(
            'Không có dữ liệu outfit',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      },
    );
  }
}