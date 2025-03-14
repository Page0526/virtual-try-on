import 'package:myapp/features/shop/model/product.dart';

class ProductService {
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

  List<Product> getAllProducts() => _products;

  List<Product> filterByCategory(String category) {
    if (category == 'ALL') return _products;
    return _products.where((product) => product.type == category).toList();
  }

  List<Product> searchByNaturalLanguage(String query) {
    final lowerQuery = query.toLowerCase();
    return _products.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.brand.toLowerCase().contains(lowerQuery) ||
          product.type.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}