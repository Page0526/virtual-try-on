// lib/features/closet/controller/outfit_service.dart
import 'dart:io';
import 'package:myapp/features/closet/model/outfit.dart';
import 'package:myapp/features/closet/model/outfit_category.dart';
import 'package:myapp/features/closet/model/item.dart';
import 'package:path_provider/path_provider.dart';

class OutfitService {
  final Map<String, OutfitCategory> _categories = {
    'all': const OutfitCategory(id: 'all', name: 'All Outfit'),
    'casual': const OutfitCategory(id: 'casual', name: 'Casual'),
    'formal': const OutfitCategory(id: 'formal', name: 'Formal'),
    'sporty': const OutfitCategory(id: 'sporty', name: 'Sporty'),
  };

  final Map<String, Outfit> _outfits = {
    '1': const Outfit(
      id: '1',
      name: 'Casual Friday',
      categoryId: 'casual',
      items: [],
    ),
  };

  List<OutfitCategory> getAllCategories() => _categories.values.toList();

  List<Outfit> getOutfitsByCategory(String categoryId) {
    if (categoryId == 'all') {
      return _outfits.values.toList();
    }
    return _outfits.values.where((outfit) => outfit.categoryId == categoryId).toList();
  }

  List<Outfit> getAllOutfits() => _outfits.values.toList();

  Outfit? getOutfitById(String id) => _outfits[id];

  void addOutfit(Outfit outfit) {
    _outfits[outfit.id] = outfit;
  }

  Future<Outfit> addOutfitWithImage(Outfit outfit, List<int> imageBytes) async {
    // Lưu hình ảnh vào một file tạm thời
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/outfit_${outfit.id}.jpg';
    await File(imagePath).writeAsBytes(imageBytes);

    // Tạo Outfit mới với imageUrl
    final updatedOutfit = outfit.copyWith(imageUrl: imagePath);
    _outfits[outfit.id] = updatedOutfit;
    return updatedOutfit;
  }

  void updateOutfit(Outfit updatedOutfit) {
    if (_outfits.containsKey(updatedOutfit.id)) {
      _outfits[updatedOutfit.id] = updatedOutfit;
    }
  }

  void deleteOutfit(String outfitId) {
    _outfits.remove(outfitId);
  }

  void addItemToOutfit(String outfitId, Item item) {
    final outfit = _outfits[outfitId];
    if (outfit != null) {
      final updatedItems = List<Item>.from(outfit.items)..add(item);
      _outfits[outfitId] = outfit.copyWith(items: updatedItems);
    }
  }

  void removeItemFromOutfit(String outfitId, String itemId) {
    final outfit = _outfits[outfitId];
    if (outfit != null) {
      final updatedItems = List<Item>.from(outfit.items)..removeWhere((item) => item.id == itemId);
      _outfits[outfitId] = outfit.copyWith(items: updatedItems);
    }
  }
}