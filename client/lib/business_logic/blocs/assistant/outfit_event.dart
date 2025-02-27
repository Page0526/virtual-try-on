// lib/business_logic/bloc/outfit_event.dart
import 'package:equatable/equatable.dart';

abstract class OutfitEvent extends Equatable {
  const OutfitEvent();

  @override
  List<Object> get props => [];
}

class GetOutfitSuggestions extends OutfitEvent {
  final String itemId;
  final String? occasion;

  const GetOutfitSuggestions({required this.itemId, this.occasion});

  @override
  List<Object> get props => [itemId, occasion ?? ''];
}