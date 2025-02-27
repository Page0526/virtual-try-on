// lib/business_logic/bloc/outfit_state.dart
import 'package:equatable/equatable.dart';
import 'package:myapp/data/models/outfit.dart';

abstract class OutfitState extends Equatable {
  const OutfitState();

  @override
  List<Object> get props => [];
}

class OutfitInitial extends OutfitState {}

class OutfitLoading extends OutfitState {}

class OutfitLoaded extends OutfitState {
  final List<Outfit> outfits;

  const OutfitLoaded(this.outfits);

  @override
  List<Object> get props => [outfits];
}

class OutfitError extends OutfitState {
  final String message;

  const OutfitError(this.message);

  @override
  List<Object> get props => [message];
}