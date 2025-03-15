import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/shop/controller/shop_service.dart';
import 'package:myapp/features/shop/model/product.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late Future<List<Product>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = ProductService().searchByDescription(widget.query);
  }

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
          child: FutureBuilder<List<Product>>(
            future: _searchResults,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Không tìm thấy sản phẩm nào.'));
              }

              final products = snapshot.data!;
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
                children: products.map((product) {
                  return _buildProductCard(
                    context,
                    name: product.name,
                    price: product.price,
                    itemImage: product.itemImage,
                    brand: product.brand,
                    date: product.date,
                    type: product.type,
                    imageData: product.imageData, // Truyền imageData
                  );
                }).toList(),
              );
            },
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
    String? imageData,
  }) {
    Widget imageWidget;
    if (imageData != null && imageData.isNotEmpty) {
      try {
        final bytes = base64Decode(imageData);
        imageWidget = Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/placeholder.jpg',
            fit: BoxFit.cover,
          ),
        );
      } catch (e) {
        imageWidget = Image.asset(
          'assets/images/placeholder.jpg',
          fit: BoxFit.cover,
        );
      }
    } else {
      imageWidget = Image.asset(
        itemImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/placeholder.jpg',
          fit: BoxFit.cover,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        context.push(
          Uri(
            path: '/item',
            queryParameters: {
              'itemImage': itemImage,
              'brand': brand,
              'date': date,
              'type': type,
              'imageData': imageData ?? '', 
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
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageWidget,
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