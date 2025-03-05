// lib/features/closet/controller/outfit_event.dart
import 'dart:typed_data';
import 'package:myapp/features/closet/model/outfit.dart';

abstract class OutfitEvent {}

class LoadOutfits extends OutfitEvent {}

class AddOutfitWithImage extends OutfitEvent {
  final Outfit outfit;
  final List<int> imageBytes;

  AddOutfitWithImage(this.outfit, this.imageBytes);
}