// lib/features/closet/controller/outfit_state.dart
import 'package:myapp/features/closet/model/outfit.dart';

abstract class OutfitState {}

class OutfitInitial extends OutfitState {}

class OutfitLoading extends OutfitState {}

class OutfitLoaded extends OutfitState {
  final List<Outfit> outfits;

  OutfitLoaded(this.outfits);
}

class OutfitError extends OutfitState {
  final String message;

  OutfitError(this.message);
}