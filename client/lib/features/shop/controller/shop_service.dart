import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/features/shop/model/product.dart';

class ProductService {
  static const String serverUrl = 'https://ad26-34-45-79-223.ngrok-free.app/search_by_description';

  final List<Product> _products = [
    
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

        return Product(
          name: name,
          price: 0.0, // Giá không có trong dữ liệu server
          itemImage: imageData ?? 'assets/images/placeholder.jpg', // Sử dụng imageData trực tiếp
          brand: 'Unknown',
          date: '2023',
          type: 'Unknown',
          imageData: imageData, // Thêm trường để lưu base64
        );
      }).toList();

      return products;
    } catch (e) {
      throw Exception('Lỗi khi gửi yêu cầu: $e');
    }
  }
}