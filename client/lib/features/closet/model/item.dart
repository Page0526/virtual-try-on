// lib/features/closet/model/item.dart
class Item {
  final String id;
  final String name;
  final String type;
  final String imageUrl;
  final String? color;
  final DateTime? purchaseDate;
  final String? brand;
  final String? date;

  const Item({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    this.color,
    this.purchaseDate,
    this.brand,
    this.date,
  });

  Item copyWith({
    String? id,
    String? name,
    String? type,
    String? imageUrl,
    String? color,
    DateTime? purchaseDate,
    String? brand,
    String? date,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      brand: brand ?? this.brand,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'imageUrl': imageUrl,
        'color': color,
        'purchaseDate': purchaseDate?.toIso8601String(),
        'brand': brand,
        'date': date,
      };

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        imageUrl: json['imageUrl'] as String,
        color: json['color'] as String?,
        purchaseDate: json['purchaseDate'] != null ? DateTime.parse(json['purchaseDate'] as String) : null,
        brand: json['brand'] as String?,
        date: json['date'] as String?,
      );
}