// lib/data/services/clothing_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/item.dart';
import '../model/outfit.dart';


class ClothingService {
  final String baseUrl = 'https://your-api-endpoint.com/api'; // Thay bằng URL API thực tế

  Future<Item> addClothingItem(Item item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clothing'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': item.id,
        'name': item.name,
        'type': item.type,
        'image_url': item.imageUrl,
      }),
    );
    if (response.statusCode == 201) {
      try {
        return Item.fromJson(jsonDecode(response.body));
      } catch (e) {
        throw Exception('Lỗi parse dữ liệu: ${response.body}');
      }
    } else {
      throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Item>> getClothingItems() async {
    final response = await http.get(Uri.parse('$baseUrl/clothing'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => Item.fromJson(json)).toList();
        } else {
          throw Exception('Dữ liệu không phải danh sách: ${response.body}');
        }
      } catch (e) {
        throw Exception('Lỗi parse dữ liệu: ${response.body} - $e');
      }
    } else {
      throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Item> updateClothingItem(String id, Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clothing/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': item.id,
        'name': item.name,
        'type': item.type,
        'image_url': item.imageUrl,
      }),
    );
    if (response.statusCode == 200) {
      try {
        return Item.fromJson(jsonDecode(response.body));
      } catch (e) {
        throw Exception('Lỗi parse dữ liệu: ${response.body}');
      }
    } else {
      throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Outfit> saveOutfit(Outfit outfit) async {
    final response = await http.post(
      Uri.parse('$baseUrl/outfits'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': outfit.id,
        'items': outfit.items
            .map((item) => {'id': item.id, 'name': item.name, 'type': item.type, 'image_url': item.imageUrl})
            .toList(),
        'occasion': outfit.occasion,
      }),
    );
    if (response.statusCode == 201) {
      try {
        return Outfit.fromJson(jsonDecode(response.body));
      } catch (e) {
        throw Exception('Lỗi parse dữ liệu: ${response.body}');
      }
    } else {
      throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Outfit>> getOutfits() async {
    final response = await http.get(Uri.parse('$baseUrl/outfits'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => Outfit.fromJson(json)).toList();
        } else {
          throw Exception('Dữ liệu không phải danh sách: ${response.body}');
        }
      } catch (e) {
        throw Exception('Lỗi parse dữ liệu: ${response.body} - $e');
      }
    } else {
      throw Exception('Lỗi server: ${response.statusCode} - ${response.body}');
    }
  }
}