import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/closet/controller/clothing_bloc.dart';
import 'package:myapp/features/closet/controller/clothing_event.dart';
import 'package:myapp/features/closet/controller/clothing_state.dart';

class ClosetDetailScreen extends StatefulWidget {
  final String closetId;
  final String closetName;

  const ClosetDetailScreen({
    super.key,
    required this.closetId,
    required this.closetName,
  });

  @override
  State<ClosetDetailScreen> createState() => _ClosetDetailScreenState();
}

class _ClosetDetailScreenState extends State<ClosetDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClothingBloc>().add(LoadClothingItems(widget.closetId));
  }

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
          onPressed: () => context.push('/closet'),
        ),
        title: Text(
          widget.closetName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 8,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_box_outline_blank, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'option1', child: Text('Tùy chọn 1')),
              const PopupMenuItem(value: 'option2', child: Text('Tùy chọn 2')),
            ],
            onSelected: (value) {},
          ),
        ],
      ),
      body: BlocBuilder<ClothingBloc, ClothingState>(
        builder: (context, state) {
          if (state is ClothingLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          } else if (state is ClothingLoaded) {
            final items = state.items;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: SizedBox(
                    width: 250,
                    child: DropdownButton<String>(
                      
                      value: 'Recently added',
                      items: ['Recently added', 'Price', 'Date'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                          
                        );
                      }).toList(),
                      onChanged: (value) {},
                      isExpanded: true,
                      dropdownColor: Color(0xFFFFFDEC),
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'Chưa có món đồ nào',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              child: InkWell(
                                onTap: () => context.push(
                                  '/clothes?itemImage=${Uri.encodeComponent(item.imageUrl)}&brand=${Uri.encodeComponent(item.brand ?? 'No Brand')}&date=${Uri.encodeComponent(item.date ?? '')}&type=${Uri.encodeComponent(item.type)}',
                                ),
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(item.imageUrl),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.type,
                                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                            ),
                                            Text(
                                              item.brand ?? 'Không có thương hiệu',
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                            ),
                                            Text(
                                              item.date ?? 'Không có ngày',
                                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          } else if (state is ClothingError) {
            return Center(
              child: Text(
                'Lỗi: ${state.message}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text(
              'Chưa có món đồ nào',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFB3D8A8),
        onPressed: () async {
          await context.push('/closet/add-clothing-item?closetId=${widget.closetId}');
          context.read<ClothingBloc>().add(LoadClothingItems(widget.closetId));
        },
        child: const Icon(Icons.add, color: Color(0xFFFFFDEC)),
      ),
    );
  }
}