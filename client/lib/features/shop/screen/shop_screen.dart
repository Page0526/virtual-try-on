import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/utils/const/graphic/color.dart';

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

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  String _selectedCategory = 'ALL';
  final TextEditingController _searchController = TextEditingController();

  final List<Product> _products = [
    Product(
      name: 'Black Crew Neck T-Shirt',
      price: 100,
      itemImage: 'assets/images/shop1.png',
      brand: 'Generic',
      date: '2023',
      type: 'T-Shirt',
    ),
    Product(
      name: 'White Crew Neck T-Shirt',
      price: 100,
      itemImage: 'assets/images/shop1.png',
      brand: 'Generic',
      date: '2023',
      type: 'T-Shirt',
    ),
    Product(
      name: 'Pink Crew Neck T-Shirt',
      price: 100,
      itemImage: 'assets/images/shop1.png',
      brand: 'Generic',
      date: '2023',
      type: 'T-Shirt',
    ),
    Product(
      name: 'Blue Jeans',
      price: 150,
      itemImage: 'assets/images/shop1.png',
      brand: "Levi's",
      date: '2023',
      type: 'Jeans',
    ),
    Product(
      name: 'Black Jacket',
      price: 200,
      itemImage: 'assets/images/shop1.png',
      brand: 'Zara',
      date: '2023',
      type: 'Outer',
    ),
    Product(
      name: 'Denim Jacket',
      price: 180,
      itemImage: 'assets/images/shop1.png',
      brand: 'H&M',
      date: '2023',
      type: 'Outer',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _selectedCategory == 'ALL'
        ? _products
        : _products.where((product) => product.type == _selectedCategory).toList();

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
          'Cửa Hàng Thời Trang',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 8,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                onSubmitted: (value) {
                  context.push('/shop/search');
                },
              ),
              const SizedBox(height: 24),
              // Category tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryTab(context, 'ALL'),
                    const SizedBox(width: 12),
                    _buildCategoryTab(context, 'T-Shirt'),
                    const SizedBox(width: 12),
                    _buildCategoryTab(context, 'Jeans'),
                    const SizedBox(width: 12),
                    _buildCategoryTab(context, 'Outer'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Product grid
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'Không tìm thấy sản phẩm nào',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65,
                        children: filteredProducts.map((product) {
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

  Widget _buildCategoryTab(BuildContext context, String title) {
    bool isActive = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFFFFCFB3) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2))]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
    return Card(
      color: Color(0xFFFFCFB3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          context.push(
            Uri(
              path: '/item',
              queryParameters: {'itemImage': itemImage, 'brand': brand, 'date': date, 'type': type},
            ).toString(),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  itemImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}