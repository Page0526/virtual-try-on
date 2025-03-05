// lib/features/shop/screen/search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Mô hình dữ liệu cho sản phẩm
class Product {
  final String name;
  final double price;
  final String itemImage;
  final String brand;
  final String date;
  final String type;

  Product({
    required this.name,
    required this.price,
    required this.itemImage,
    required this.brand,
    required this.date,
    required this.type,
  });
}

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  // Danh sách sản phẩm cố định
  static List<Product> _products = [
    Product(
      name: 'Black Crew Neck T-Shirt',
      price: 100,
      itemImage: 'assets/images/black_crew_neck_tshirt.jpg',
      brand: 'Generic',
      date: '2023',
      type: 'T-Shirt',
    ),
    Product(
      name: 'White Crew Neck T-Shirt',
      price: 100,
      itemImage: 'assets/images/white_crew_neck_tshirt.jpg',
      brand: 'Generic',
      date: '2023',
      type: 'T-Shirt',
    ),
    Product(
      name: 'Pink Crew Neck T-Shirt',
      price: 100,
      itemImage: 'assets/images/pink_crew_neck_tshirt.jpg',
      brand: 'Generic',
      date: '2023',
      type: 'T-Shirt',
    ),
     Product(
      name: 'Blue Jeans',
      price: 150,
      itemImage: 'assets/images/blue_jeans.jpg',
      brand: 'Levi\'s',
      date: '2023',
      type: 'Jeans',
    ),
     Product(
      name: 'Black Jacket',
      price: 200,
      itemImage: 'assets/images/black_jacket.jpg',
      brand: 'Zara',
      date: '2023',
      type: 'Outer',
    ),
     Product(
      name: 'Denim Jacket',
      price: 180,
      itemImage: 'assets/images/denim_jacket.jpg',
      brand: 'H&M',
      date: '2023',
      type: 'Outer',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: const Text('Kết quả tìm kiếm'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Product grid
              Expanded(
                child: _products.isEmpty
                    ? const Center(child: Text('Không có sản phẩm nào.'))
                    : GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                        children: _products.map((product) {
                          return _buildProductCard(
                            context,
                            name: product.name,
                            price: product.price,
                            itemImage: product.itemImage,
                            brand: product.brand,
                            date: product.date,
                            type: product.type,
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context, {
    required String name,
    required double price,
    required String itemImage,
    required String brand,
    required String date,
    required String type,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to /item with query parameters
        context.go(
          Uri(
            path: '/item',
            queryParameters: {
              'itemImage': itemImage,
              'brand': brand,
              'date': date,
              'type': type,
            },
          ).toString(),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage(itemImage),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Hiển thị placeholder nếu hình ảnh không tải được
                      const AssetImage('assets/images/placeholder.jpg');
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}