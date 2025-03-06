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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Chi Tiết Outfit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 8,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                      child: outfit.imageBytes != null
                          ? Image.memory(
                              Uint8List.fromList(outfit.imageBytes!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                              ),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 100, color: Colors.grey),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          outfit.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Danh mục: ${outfit.categoryId}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
        },
      ),
    );
  }
}