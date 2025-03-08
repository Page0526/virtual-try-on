import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/closet/model/outfit.dart';
import 'package:myapp/utils/const/graphic/color.dart';
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
            color: CusColor.barColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: CusColor.primaryTextColor),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Chi Tiết Outfit',
          style: TextStyle(color:  CusColor.primaryTextColor, fontWeight: FontWeight.w600, fontSize: 18),
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
                          color: Colors.black.withValues(alpha: 0.2),
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
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: CusColor.primaryTextColor),
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