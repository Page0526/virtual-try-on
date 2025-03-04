// lib/features/closet/controller/clothing_event.dart
import 'package:myapp/features/closet/model/item.dart';

abstract class ClothingEvent {}

class LoadClothingItems extends ClothingEvent {
  final String closetId;
  LoadClothingItems(this.closetId);
}

class AddClothingItem extends ClothingEvent {
  final String closetId;
  final Item item;
  AddClothingItem(this.closetId, this.item);
}

class UpdateClothingItem extends ClothingEvent {
  final String closetId;
  final Item updatedItem;
  UpdateClothingItem(this.closetId, this.updatedItem);
}

class DeleteClothingItem extends ClothingEvent {
  final String closetId;
  final String itemId;
  DeleteClothingItem(this.closetId, this.itemId);
}