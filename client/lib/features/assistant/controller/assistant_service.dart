import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class SuggestionItem {
  final String category;
  final String name;
  final String? imageData;
  final String suggestions;

  SuggestionItem({
    required this.category,
    required this.name,
    this.imageData,
    required this.suggestions,
  });

  factory SuggestionItem.fromJson(Map<String, dynamic> json) {
    return SuggestionItem(
      category: json['category'] ?? '',
      name: json['name'] ?? 'Không có mô tả',
      imageData: json['image_data'] as String?,
      suggestions: json['suggestions'] ?? '',
    );
  }
}

class AssistantService {
  static const String serverUrl = 'https://5ff4-34-45-79-223.ngrok-free.app/suggest_combinations';

  Future<List<SuggestionItem>> suggestCombinations(List<int> outfitImageBytes) async {
    try {
      // Tạo multipart request để gửi ảnh
      var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
      request.files.add(
        http.MultipartFile.fromBytes(
          'outfit_img',
          outfitImageBytes,
          filename: 'outfit.jpg',
        ),
      );

      // Gửi request và nhận response
      var response = await request.send();
      if (response.statusCode != 200) {
        final errorBody = await response.stream.bytesToString();
        throw Exception('Lỗi server: ${response.statusCode} - $errorBody');
      }

      // Đọc và xử lý dữ liệu trả về
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);
      final suggestions = jsonData['suggestions'] as List<dynamic>;

      // Chuyển đổi dữ liệu thành danh sách SuggestionItem
      final List<SuggestionItem> suggestionItems = suggestions.map((item) {
        return SuggestionItem.fromJson(item);
      }).toList();

      return suggestionItems.isEmpty ? [] : suggestionItems;
    } catch (e) {
      throw Exception('Lỗi khi gửi yêu cầu: $e');
    }
  }
}