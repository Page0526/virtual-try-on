// lib/features/closet/model/outfit.dart
import 'package:myapp/features/closet/model/item.dart';

class Outfit {
  final String id;
  final String name;
  final String categoryId;
  final String? imageUrl; // Thêm thuộc tính imageUrl để lưu đường dẫn hình ảnh
  final List<Item> items;

  const Outfit({
    required this.id,
    required this.name,
    required this.categoryId,
    this.imageUrl,
    this.items = const [],
  });

  Outfit copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? imageUrl,
    List<Item>? items,
  }) {
    return Outfit(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      items: items ?? this.items,
    );
  }
}