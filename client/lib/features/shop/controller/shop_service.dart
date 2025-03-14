import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/features/shop/model/product.dart';

class ProductService {
  static const String serverUrl = 'https://354a-34-169-25-87.ngrok-free.app/search_by_description';

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

  Future<List<Product>> searchByDescription(String description) async {
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'description': description}),
      );

      if (response.statusCode != 200) {
        throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
      }

      final jsonData = jsonDecode(response.body);
      final results = jsonData['results'] as List<dynamic>;

      // Chuyển đổi kết quả từ server thành danh sách Product
      final List<Product> products = results.map((item) {
        final name = item['name'] ?? 'Không có tên';
        final imageData = item['image_data'] as String?;
        String itemImage = 'assets/images/placeholder.jpg'; // Placeholder mặc định

        return Product(
          name: name,
          price: 0.0, // Giá không có trong dữ liệu server, đặt mặc định
          itemImage: itemImage,
          brand: 'Unknown', // Không có trong dữ liệu server
          date: '2023', // Giá trị mặc định
          type: 'Unknown', // Không có trong dữ liệu server
        );
      }).toList();

      return products;
    } catch (e) {
      throw Exception('Lỗi khi gửi yêu cầu: $e');
    }
  }
}