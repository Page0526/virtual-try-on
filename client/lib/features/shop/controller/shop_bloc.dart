import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/shop/controller/shop_service.dart';
import 'package:myapp/features/shop/model/product.dart';
import 'shop_event.dart';
import 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ProductService productService;

  ShopBloc(this.productService) : super(ShopInitial()) {
    on<LoadProducts>((event, emit) {
      emit(ShopLoading());
      final products = productService.getAllProducts();
      emit(ShopLoaded(products));
    });

    on<FilterByCategory>((event, emit) {
      emit(ShopLoading());
      final currentState = state;
      String currentQuery = '';
      if (currentState is ShopLoaded) {
        currentQuery = currentState.searchQuery ?? '';
      }
      List<Product> products = productService.filterByCategory(event.category);
      if (currentQuery.isNotEmpty) {
        products = productService.searchByNaturalLanguage(currentQuery).where((p) => event.category == 'ALL' || p.type == event.category).toList();
      }
      emit(ShopLoaded(products, selectedCategory: event.category, searchQuery: currentQuery));
    });

    on<SearchProducts>((event, emit) {
      emit(ShopLoading());
      final currentState = state;
      String currentCategory = 'ALL';
      if (currentState is ShopLoaded) {
        currentCategory = currentState.selectedCategory;
      }
      List<Product> products = event.query.isEmpty
          ? productService.getAllProducts()
          : productService.searchByNaturalLanguage(event.query);
      if (currentCategory != 'ALL') {
        products = products.where((p) => p.type == currentCategory).toList();
      }
      emit(ShopLoaded(products, selectedCategory: currentCategory, searchQuery: event.query));
    });
  }
}