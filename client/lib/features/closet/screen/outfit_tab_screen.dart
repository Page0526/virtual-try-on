// lib/features/closet/screen/outfit_tab_screen.dart
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
          return const Center(child: CircularProgressIndicator());
        } else if (state is OutfitLoaded) {
          final outfits = state.outfits;
          if (outfits.isEmpty) {
            return const Center(child: Text('Không có outfit nào.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: outfits.length,
            itemBuilder: (context, index) {
              final outfit = outfits[index];
              return Card(
                color: Color(0xFFB3D8A8),
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  leading: outfit.imageBytes != null
                      ? SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.memory(
                            Uint8List.fromList(outfit.imageBytes!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 60,
                                color: Colors.grey,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.grey,
                        ),
                  title: Text(outfit.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600 ),),
                  subtitle: Text(outfit.categoryId, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300 )),
                  onTap: () {
                    context.push('/closet/outfit/${outfit.id}');
                  },
                ),
              );
            },
          );
        } else if (state is OutfitError) {
          return Center(child: Text('Lỗi: ${state.message}'));
        }
        return const Center(child: Text('Không có dữ liệu outfit.'));
      },
    );
  }
}