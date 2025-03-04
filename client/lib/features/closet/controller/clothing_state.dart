// lib/features/closet/controller/clothing_state.dart
import 'package:myapp/features/closet/model/item.dart';

abstract class ClothingState {}

class ClothingInitial extends ClothingState {}

class ClothingLoading extends ClothingState {}

class ClothingLoaded extends ClothingState {
  final List<Item> items;
  ClothingLoaded(this.items);
}

class ClothingError extends ClothingState {
  final String message;
  ClothingError(this.message);
}