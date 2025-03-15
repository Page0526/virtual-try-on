import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TryOnService {
  static const String _baseUrl = 'https://a2d1-34-87-94-79.ngrok-free.app';

  Future<List<int>> tryOnTest(File personImage, File clothImage) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      ByteData data = await rootBundle.load('assets/images/test.jpg');
      List<int> fakeImageBytes = data.buffer.asUint8List();
      return fakeImageBytes;
    } catch (e) {
      throw Exception('Lỗi giả lập: Không thể tạo dữ liệu hình ảnh: $e');
    }
  }

  Future<List<int>> tryOn(File personImage, File clothImage) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/tryon/'));

      request.files.add(await http.MultipartFile.fromPath(
        'file1',
        personImage.path,
        filename: 'person.jpg',
      ));

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
      // Create a multipart request to the evaluate_outfit endpoint
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://5ff4-34-45-79-223.ngrok-free.app/evaluate_outfit'),
      );

      // Add the image bytes as a multipart file
      request.files.add(
        http.MultipartFile.fromBytes(
          'outfit_img',
          outfitImageBytes,
          filename: 'outfit.jpg',
        ),
      );

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Parse the JSON response
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        return jsonData['analysis'] as String;
      } else {
        var errorMessage = await response.stream.bytesToString();
        throw Exception('Evaluate outfit failed: $errorMessage');
      }
    } catch (e) {
      throw Exception('Error during outfit evaluation: $e');
    }
  }
}