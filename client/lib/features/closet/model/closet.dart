// lib/features/closet/model/closet.dart
import 'package:myapp/features/closet/model/item.dart';

class Closet {
  final String id;
  final String name;
  final List<Item> items;

  const Closet({
    required this.id,
    required this.name,
    this.items = const [],
  });

  Closet copyWith({
    String? id,
    String? name,
    List<Item>? items,
  }) {
    return Closet(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
    );
  }
}