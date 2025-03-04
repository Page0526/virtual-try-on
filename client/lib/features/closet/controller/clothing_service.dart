// lib/features/closet/controller/clothing_service.dart
import 'package:myapp/features/closet/controller/closet_service.dart';
import 'package:myapp/features/closet/model/item.dart';

class ClothingService {
  final ClosetService _closetService;

  ClothingService(this._closetService);

  List<Item> getItemsForCloset(String closetId) {
    final closet = _closetService.getClosetById(closetId);
    return closet?.items ?? [];
  }

  void addItemToCloset(String closetId, Item item) {
    final closet = _closetService.getClosetById(closetId);
    if (closet != null) {
      final updatedItems = List<Item>.from(closet.items)..add(item);
      _closetService.updateCloset(closet.copyWith(items: updatedItems));
    }
  }

  void updateItemInCloset(String closetId, Item updatedItem) {
    final closet = _closetService.getClosetById(closetId);
    if (closet != null) {
      final updatedItems = List<Item>.from(closet.items);
      final index = updatedItems.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        updatedItems[index] = updatedItem;
        _closetService.updateCloset(closet.copyWith(items: updatedItems));
      }
    }
  }

  void removeItemFromCloset(String closetId, String itemId) {
    final closet = _closetService.getClosetById(closetId);
    if (closet != null) {
      final updatedItems = List<Item>.from(closet.items)..removeWhere((item) => item.id == itemId);
      _closetService.updateCloset(closet.copyWith(items: updatedItems));
    }
  }
}