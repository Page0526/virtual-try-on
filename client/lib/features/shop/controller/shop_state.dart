import 'package:myapp/features/shop/model/product.dart';


abstract class ShopState {}

class ShopInitial extends ShopState {}

class ShopLoading extends ShopState {}

class ShopLoaded extends ShopState {
  final List<Product> products;
  final String selectedCategory;
  final String? searchQuery; // Thêm searchQuery

  ShopLoaded(this.products, {this.selectedCategory = 'ALL', this.searchQuery});
}

class ShopError extends ShopState {
  final String message;
  ShopError(this.message);
}