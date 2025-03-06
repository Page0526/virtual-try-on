import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/routes/routes.dart';

class SuggestedItem {
  final String name;
  final String brand;
  final String date;
  final String imageUrl;
  final String recommended;

  SuggestedItem({
    required this.name,
    required this.brand,
    required this.date,
    required this.imageUrl,
    this.recommended = '',
  });
}

class SuggestionScreen extends StatelessWidget {
  final List<int> resultImageBytes;

  const SuggestionScreen({super.key, required this.resultImageBytes});

  List<SuggestedItem> _getSuggestedItems() {
    return [
      SuggestedItem(
        name: 'Áo thun',
        brand: 'Uniqlo',
        imageUrl: 'assets/images/rcm.png',
        recommended: 'Phù hợp với phong cách năng động',
        date: '2023',
      ),
      SuggestedItem(
        name: 'Áo Phao',
        brand: 'The North Face',
        imageUrl: 'assets/images/rcm1.png',
        recommended: 'Giữ ấm tốt, hợp mùa đông',
        date: '2023',
      ),
      SuggestedItem(
        name: 'Mũ Lưỡi Trai',
        brand: 'Nike',
        imageUrl: 'assets/images/rcm2.png',
        recommended: 'Thêm điểm nhấn cá tính',
        date: '2023',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final suggestedItems = _getSuggestedItems();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh kết quả
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.memory(
                      Uint8List.fromList(resultImageBytes),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Tiêu đề gợi ý
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
            ],
          ),
        ),
      ),
    );
  }
}