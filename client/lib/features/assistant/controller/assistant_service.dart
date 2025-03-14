import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AssistantService {
  static const String serverUrl = 'https://354a-34-169-25-87.ngrok-free.app/suggest_combinations';

  Future<String> suggestCombinations(List<int> outfitImageBytes) async {
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
        return 'Lỗi server: ${response.statusCode} - $errorBody';
      }

      // Đọc và xử lý dữ liệu trả về
      final responseData = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseData);
      final suggestions = jsonData['suggestions'] as List<dynamic>;

      // Chuyển đổi dữ liệu thành định dạng yêu cầu
      StringBuffer result = StringBuffer();
      for (var item in suggestions) {
        final category = item['category'] ?? '';
        final name = item['name'] ?? 'Không có mô tả';
        switch (category) {
          case 'Áo':
            result.writeln('Áo: $name');
            break;
          case 'Quần':
            result.writeln('Quần: $name');
            break;
          case 'Mũ':
            result.writeln('Mũ: $name');
            break;
          case 'Phụ kiện đi kèm':
            result.writeln('Phụ kiện đi kèm: $name');
            break;
        }
      }

      return result.toString().isEmpty ? 'Không có gợi ý nào.' : result.toString();
    } catch (e) {
      return 'Lỗi khi gửi yêu cầu: $e';
    }
  }
}