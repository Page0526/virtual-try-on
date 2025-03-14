import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TryOnService {
  static const String _baseUrl = 'https://924e-34-75-213-51.ngrok-free.app';

  Future<List<int>> tryOnTest(File personImage, File clothImage) async {
    try {
        // Giả lập độ trễ của API
        await Future.delayed(const Duration(seconds: 2));

        ByteData data = await rootBundle.load('assets/images/test.jpg');
        List<int> fakeImageBytes = data.buffer.asUint8List();

        // Trả về dữ liệu giả lập
        return fakeImageBytes;
      } catch (e) {
        // Giả lập lỗi nếu cần
        throw Exception('Lỗi giả lập: Không thể tạo dữ liệu hình ảnh: $e');
      }
  }

  Future<List<int>> tryOn(File personImage, File clothImage) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/tryon/'));

      // Gửi ảnh người
      request.files.add(await http.MultipartFile.fromPath(
        'file1',
        personImage.path,
        filename: 'person.jpg',
      ));

      // Gửi ảnh quần áo
      request.files.add(await http.MultipartFile.fromPath(
        'file2',
        clothImage.path,
        filename: 'cloth.jpg',
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.toBytes();
      } else {
        var errorMessage = await response.stream.bytesToString();
        throw Exception('Try-on failed: $errorMessage');
      }
    } catch (e) {
      throw Exception('Error during try-on: $e');
    }
  }

  Future<String> evaluateOutfit(List<int> outfitImageBytes) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/evaluate_outfit'));

      // Gửi bytes trực tiếp
      request.files.add(http.MultipartFile.fromBytes(
        'outfit_img',
        outfitImageBytes,
        filename: 'outfit.jpg',
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = jsonDecode(responseData);
        return jsonData['analysis'] ?? 'No valid analysis received';
      } else {
        var errorMessage = await response.stream.bytesToString();
        throw Exception('Evaluation failed: $errorMessage');
      }
    } catch (e) {
      throw Exception('Error during outfit evaluation: $e');
    }
  }
}