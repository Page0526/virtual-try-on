
import 'item.dart';
// lib/data/models/outfit.dart
class Outfit {
  final String id;
  final List<Item> items;
  final String occasion; // Ví dụ: "công sở", "dạo phố"

  Outfit({
    required this.id,
    required this.items,
    required this.occasion,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      id: json['id'],
      items: (json['items'] as List).map((i) => Item.fromJson(i)).toList(),
      occasion: json['occasion'],
    );
  }
}