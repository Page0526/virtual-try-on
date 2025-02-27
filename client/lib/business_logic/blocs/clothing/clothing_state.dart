// lib/business_logic/bloc/clothing_state.dart
import 'package:equatable/equatable.dart';
import 'package:myapp/data/models/item.dart';
import 'package:myapp/data/models/outfit.dart';

abstract class ClothingState extends Equatable {
  const ClothingState();
  @override
  List<Object> get props => [];
}

class ClothingInitial extends ClothingState {}
class ClothingLoading extends ClothingState {}
class ClothingLoaded extends ClothingState {
  final List<Item> items;
  final List<Outfit> outfits;
  const ClothingLoaded(this.items, this.outfits);
  @override
  List<Object> get props => [items, outfits];
}
class ClothingError extends ClothingState {
  final String message;
  const ClothingError(this.message);
  @override
  List<Object> get props => [message];
}