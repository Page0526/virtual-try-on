// lib/features/closet/model/outfit.dart
class Outfit {
  final String id;
  final String name;
  final String categoryId;
  final List<int>? imageBytes;

  Outfit({
    required this.id,
    required this.name,
    required this.categoryId,
    this.imageBytes,
  });
}