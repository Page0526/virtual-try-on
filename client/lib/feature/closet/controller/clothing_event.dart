// lib/business_logic/bloc/clothing_event.dart
import 'package:equatable/equatable.dart';
import '../model/outfit.dart';
import '../model/item.dart';


abstract class ClothingEvent extends Equatable {
  const ClothingEvent();
  @override
  List<Object> get props => [];
}

class LoadClothingItems extends ClothingEvent {}
class AddClothingItem extends ClothingEvent {
  final Item item;
  const AddClothingItem(this.item);
  @override
  List<Object> get props => [item];
}
class UpdateClothingItem extends ClothingEvent {
  final String id;
  final Item item;
  const UpdateClothingItem(this.id, this.item);
  @override
  List<Object> get props => [id, item];
}
class SaveOutfit extends ClothingEvent {
  final Outfit outfit;
  const SaveOutfit(this.outfit);
  @override
  List<Object> get props => [outfit];
}