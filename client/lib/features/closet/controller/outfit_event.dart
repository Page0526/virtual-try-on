// lib/features/closet/controller/outfit_event.dart
import 'package:myapp/features/closet/model/outfit.dart';
import 'package:myapp/features/closet/model/item.dart';

abstract class OutfitEvent {}

class LoadOutfitCategories extends OutfitEvent {}

class LoadOutfitsByCategory extends OutfitEvent {
  final String categoryId;
  LoadOutfitsByCategory(this.categoryId);
}

class AddOutfit extends OutfitEvent {
  final Outfit outfit;
  AddOutfit(this.outfit);
}

class AddOutfitWithImage extends OutfitEvent {
  final Outfit outfit;
  final List<int> imageBytes;
  AddOutfitWithImage(this.outfit, this.imageBytes);
}

class UpdateOutfit extends OutfitEvent {
  final Outfit updatedOutfit;
  UpdateOutfit(this.updatedOutfit);
}

class DeleteOutfit extends OutfitEvent {
  final String outfitId;
  DeleteOutfit(this.outfitId);
}

class AddItemToOutfit extends OutfitEvent {
  final String outfitId;
  final Item item;
  AddItemToOutfit(this.outfitId, this.item);
}

class RemoveItemFromOutfit extends OutfitEvent {
  final String outfitId;
  final String itemId;
  RemoveItemFromOutfit(this.outfitId, this.itemId);
}