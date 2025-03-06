// lib/features/closet/screen/closet_detail_screen.dart
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/closet'),
        ),
        title: Text(widget.closetName),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_box_outline_blank),
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
      body: BlocBuilder<ClothingBloc, ClothingState>(
        builder: (context, state) {
          if (state is ClothingLoading) {
            return const Center(child: CircularProgressIndicator());
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
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: InkWell(
                          onTap: () => context.push(
                            '/clothes?itemImage=${Uri.encodeComponent(item.imageUrl)}&brand=${Uri.encodeComponent(item.brand ?? 'No Brand')}&date=${Uri.encodeComponent(item.date ?? '')}&type=${Uri.encodeComponent(item.type)}',
                          ),
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
                    },
                  ),
                ),
              ],
            );
          } else if (state is ClothingError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Chưa có món đồ nào'));
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