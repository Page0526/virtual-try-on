abstract class ShopEvent {}

class LoadProducts extends ShopEvent {}

class FilterByCategory extends ShopEvent {
  final String category;
  FilterByCategory(this.category);
}

class SearchProducts extends ShopEvent {
  final String query;
  SearchProducts(this.query);
}