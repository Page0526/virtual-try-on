import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/routes/routes.dart';
import 'package:myapp/utils/const/graphic/color.dart';

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
            color: CusColor.barColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Gợi Ý Trang Phục',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 8,
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
                        color: Colors.black.withValues(alpha: 0.2),
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
                'Trang Phục Phù Hợp Với Bạn',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              // Danh sách gợi ý
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: suggestedItems.length,
                itemBuilder: (context, index) {
                  final item = suggestedItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      color: Color(0xFFFFCFB3),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () {
                          context.push(
                            Uri(
                              path: AppRoutes.item,
                              queryParameters: {
                                'itemImage': item.imageUrl,
                                'brand': item.brand,
                                'date': item.date,
                                'type': item.name,
                              },
                            ).toString(),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Hình ảnh sản phẩm
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item.imageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[500],
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Thông tin sản phẩm
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.brand,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFE78F81).withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        item.recommended,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}