// lib/features/closet/screen/clothes_detail_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClothesDetailScreen extends StatelessWidget {
  final String itemImage;
  final String brand;
  final String date;
  final String type;

  const ClothesDetailScreen({
    super.key,
    required this.itemImage,
    required this.brand,
    required this.date,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: const Text('Clothes Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'option1', child: Text('Option 1')),
              const PopupMenuItem(value: 'option2', child: Text('Option 2')),
            ],
            onSelected: (value) {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              File(itemImage),
              fit: BoxFit.contain,
              width: double.infinity,
              height: 250,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 250),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.local_laundry_service, color: Colors.blue),
                    label: const Text('Washing', style: TextStyle(color: Colors.blue)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type: $type'),
                  Text('Brand: $brand'),
                  Text('Date: $date'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}