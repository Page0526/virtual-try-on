class Item {
  final String id;
  final String name;
  final String type;
  final String imageUrl;
  final String? color;
  final DateTime? purchaseDate;

  Item({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    this.color,
    this.purchaseDate,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      imageUrl: json['image_url'],
      color: json['color'],
      purchaseDate: json['purchase_date'] != null ? DateTime.parse(json['purchase_date']) : null,
    );
  }
}