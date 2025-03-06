// lib/features/fitting_room/suggestion_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Mô hình dữ liệu cho món đồ gợi ý
class SuggestedItem {
  final String name;
  final String type;
  final String imageUrl;

  SuggestedItem({
    required this.name,
    required this.type,
    required this.imageUrl,
  });
}

class SuggestionScreen extends StatelessWidget {
  final List<int> resultImageBytes;

  const SuggestionScreen({super.key, required this.resultImageBytes});

  // Dữ liệu giả lập cho danh sách gợi ý
  List<SuggestedItem> _getSuggestedItems() {
    return [
      SuggestedItem(
        name: 'Áo thun',
        type: 'Áo thun',
        imageUrl: 'assets/images/rcm.png', // Thay bằng đường dẫn thực tế
      ),
      SuggestedItem(
        name: 'Áo Phao',
        type: 'Áo',
        imageUrl: 'assets/images/rcm1.png',
      ),
      SuggestedItem(
        name: 'Mũ',
        type: 'Mũ',
        imageUrl: 'assets/images/rcm2.png',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final suggestedItems = _getSuggestedItems();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFFDEC), Color(0xFFFFF2AF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Gợi ý trang phục',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 4,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Hiển thị ảnh kết quả
              Center(
                child: SizedBox(
                  height: 425,
                  width: 325,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        Uint8List.fromList(resultImageBytes),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gợi ý trang phục phù hợp',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Danh sách gợi ý quần áo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: suggestedItems.length,
                  itemBuilder: (context, index) {
                    final item = suggestedItems[index];
                    return Card(
                      color: Color(0xFFFFF2AF),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: Image.asset(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 60,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        title: Text(item.name),
                        subtitle: Text(item.type),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã chọn ${item.name}')),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}