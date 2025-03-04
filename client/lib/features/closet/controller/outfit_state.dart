// lib/features/closet/controller/outfit_state.dart
import 'package:myapp/features/closet/model/outfit.dart';
import 'package:myapp/features/closet/model/outfit_category.dart';

abstract class OutfitState {}

class OutfitInitial extends OutfitState {}

class OutfitLoading extends OutfitState {}

class OutfitCategoriesLoaded extends OutfitState {
  final List<OutfitCategory> categories;
  OutfitCategoriesLoaded(this.categories);
}

class OutfitsByCategoryLoaded extends OutfitState {
  final String categoryId;
  final List<Outfit> outfits;
  OutfitsByCategoryLoaded(this.categoryId, this.outfits);
}

class OutfitError extends OutfitState {
  final String message;
  OutfitError(this.message);
}