class Product {
  final String name;
  final double price;
  final String itemImage;
  final String brand;
  final String date;
  final String type;

  Product({
    required this.name,
    required this.price,
    required this.itemImage,
    required this.brand,
    required this.date,
    required this.type,
  });

  @override
  String toString() {
    return 'Product(name: $name, price: $price, itemImage: $itemImage, brand: $brand, date: $date, type: $type)';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      itemImage: json['itemImage'] as String,
      brand: json['brand'] as String,
      date: json['date'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'itemImage': itemImage,
      'brand': brand,
      'date': date,
      'type': type,
    };
  }
}