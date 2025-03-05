// lib/features/closet/data/outfit_service.dart
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/features/closet/model/outfit.dart';

class OutfitService {
  final List<Outfit> _outfits = [];

  OutfitService() {
    // Thêm outfit giả lập khi khởi tạo
    _initializeMockData();
  }

  Future<void> _initializeMockData() async {
    // Tải hình ảnh giả lập từ assets
    ByteData data = await rootBundle.load('assets/images/image2.jpg');
    List<int> fakeImageBytes = data.buffer.asUint8List();

    // Thêm outfit giả lập
    _outfits.add(Outfit(
      id: 'mock1',
      name: 'Outfit 1',
      categoryId: 'casual',
      imageBytes: fakeImageBytes,
    ));
    _outfits.add(Outfit(
      id: 'mock2',
      name: 'Outfit 2',
      categoryId: 'formal',
      imageBytes: fakeImageBytes,
    ));
  }

  Future<List<Outfit>> getOutfits() async {
    await Future.delayed(const Duration(seconds: 1));
    return _outfits;
  }

  Future<void> addOutfit(Outfit outfit, List<int> imageBytes) async {
    await Future.delayed(const Duration(seconds: 1));
    final newOutfit = Outfit(
      id: outfit.id,
      name: outfit.name,
      categoryId: outfit.categoryId,
      imageBytes: imageBytes,
    );
    _outfits.add(newOutfit);
  }
}