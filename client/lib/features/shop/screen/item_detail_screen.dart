import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/common/widgets/navigation_bar.dart';

class ShopClothesDetailScreen extends StatefulWidget {
  final String itemImage;
  final String brand;
  final String date;
  final String type;

  const ShopClothesDetailScreen({
    super.key,
    required this.itemImage,
    required this.brand,
    required this.date,
    required this.type,
  });

  @override
  State<ShopClothesDetailScreen> createState() => _ClothesDetailScreenState();
}

class _ClothesDetailScreenState extends State<ShopClothesDetailScreen> {
  int _quantity = 1;
  Color _selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/');
          },
        ),
        title: const Text('Product Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image (using the itemImage parameter)
              Expanded(
                child: Center(
                  child: Container(
                    color: Colors.grey[200],
                    child: Text(widget.itemImage.isNotEmpty
                        ? 'Image: ${widget.itemImage}'
                        : 'Image Placeholder'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Product details (using type, brand, and date parameters)
              Text(
                widget.type,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                '${widget.brand} Crew Neck T-Shirt',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Released: ${widget.date}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              // Color options
              Row(
                children: [
                  _buildColorOption(Colors.black),
                  const SizedBox(width: 8),
                  _buildColorOption(Colors.pink),
                ],
              ),
              const SizedBox(height: 16),
              // Quantity selector
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (_quantity > 1) _quantity--;
                      });
                    },
                  ),
                  Text('$_quantity', style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                  ),
                  const Spacer(),
                  const Text(
                    '\$100',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description
              const Text(
                'Fashion is form of self-expression and autonomy at a particular period & place and in a specific context',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Add to Cart button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/cart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add To Cart',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: 3,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/closet');
              break;
            case 2:
              break;
            case 3:
              context.go('/'); // Navigate back to shop page
              break;
            case 4:
              // Navigate to settings (not implemented)
              break;
          }
        },
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    bool isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}