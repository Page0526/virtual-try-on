// lib/data/services/try_on_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class TryOnService {
  Future<List<int>> tryOn(File personImage, File clothImage) async {
    // Tạo request gửi multipart/form-data
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://a0d8-34-125-125-102.ngrok-free.app/tryon/'), // Thay bằng URL thực tế
    );

    // Thêm file1 (ảnh người)
    request.files.add(await http.MultipartFile.fromPath(
      'file1', // Tên field khớp với API
      personImage.path,
      filename: basename(personImage.path),
    ));

    // Thêm file2 (ảnh quần áo)
    request.files.add(await http.MultipartFile.fromPath(
      'file2', // Tên field khớp với API
      clothImage.path,
      filename: basename(clothImage.path),
    ));

    // Gửi request và nhận phản hồi
    var response = await request.send();

    // Kiểm tra trạng thái phản hồi
    if (response.statusCode == 200) {
      // Chuyển stream phản hồi thành dữ liệu nhị phân
      var responseData = await response.stream.toBytes();
      return responseData;
    } else {
      // Xử lý lỗi từ API
      var errorMessage = await response.stream.bytesToString();
      throw Exception('Lỗi từ API: $errorMessage');
    }
  }
}