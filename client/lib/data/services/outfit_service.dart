// lib/data/services/outfit_service.dart
import '../models/item.dart';
import '../models/outfit.dart';

class OutfitService {
  Future<List<Outfit>> getOutfitSuggestions(String itemId, String? occasion) async {
    await Future.delayed(const Duration(seconds: 1)); // Giả lập độ trễ API
    return [
      Outfit(
        id: '1',
        items: [
          Item(id: '1', name: 'Áo sơ mi trắng', type: 'shirt', imageUrl: ''),
          Item(id: '2', name: 'Quần jeans', type: 'jeans', imageUrl: ''),
        ],
        occasion: occasion ?? 'Ngẫu nhiên',
      ),
    ];
  }
}