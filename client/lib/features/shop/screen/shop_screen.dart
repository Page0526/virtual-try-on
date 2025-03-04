import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  String _selectedCategory = 'ALL'; // State to track the selected category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: const Text('Clothes Store'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search clothes...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              // Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'The most popular\nclothes today',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      '50% OFF',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Category tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategoryTab(context, 'ALL'),
                  _buildCategoryTab(context, 'Shirt'),
                  _buildCategoryTab(context, 'Jeans'),
                  _buildCategoryTab(context, 'Outer'),
                ],
              ),
              const SizedBox(height: 16),
              // Product grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                  children: [
                    _buildProductCard(
                      context,
                      name: 'Black Crew Neck T-Shirt',
                      price: 100,
                      itemImage: 'assets/images/image1.jpg',
                      brand: 'Generic',
                      date: '2023',
                      type: 'T-Shirt',
                    ),
                    _buildProductCard(
                      context,
                      name: 'Black Crew Neck T-Shirt',
                      price: 100,
                      itemImage: 'assets/images/image1.jpg',
                      brand: 'Generic',
                      date: '2023',
                      type: 'T-Shirt',
                    ),
                    _buildProductCard(
                      context,
                      name: 'Pink Crew Neck T-Shirt',
                      price: 100,
                      itemImage: 'assets/images/image1.jpg',
                      brand: 'Generic',
                      date: '2023',
                      type: 'T-Shirt',
                    ),
                    _buildProductCard(
                      context,
                      name: 'Pink Crew Neck T-Shirt',
                      price: 100,
                      itemImage: 'assets/images/image1.jpg',
                      brand: 'Generic',
                      date: '2023',
                      type: 'T-Shirt',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(BuildContext context, String title) {
    bool isActive = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
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
                color: Colors.grey[200],
                child: const Center(child: Text('Image Placeholder')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$$price', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}