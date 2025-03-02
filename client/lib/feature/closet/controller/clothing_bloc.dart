import 'package:flutter_bloc/flutter_bloc.dart';
import 'clothing_event.dart';
import 'clothing_service.dart';
import 'clothing_state.dart';

class ClothingBloc extends Bloc<ClothingEvent, ClothingState> {
  final ClothingService clothingService;

  ClothingBloc(this.clothingService) : super(ClothingInitial()) {
    on<LoadClothingItems>(_onLoadClothingItems);
    on<AddClothingItem>(_onAddClothingItem);
    on<UpdateClothingItem>(_onUpdateClothingItem);
    on<SaveOutfit>(_onSaveOutfit);
  }

  Future<void> _onLoadClothingItems(LoadClothingItems event, Emitter<ClothingState> emit) async {
    emit(ClothingLoading());
    try {
      final items = await clothingService.getClothingItems();
      final outfits = await clothingService.getOutfits();
      emit(ClothingLoaded(items, outfits));
    } catch (e) {
      emit(ClothingError(e.toString()));
    }
  }

  Future<void> _onAddClothingItem(AddClothingItem event, Emitter<ClothingState> emit) async {
    if (state is ClothingLoaded) {
      try {
        final newItem = await clothingService.addClothingItem(event.item);
        final currentState = state as ClothingLoaded;
        emit(ClothingLoaded([...currentState.items, newItem], currentState.outfits));
      } catch (e) {
        emit(ClothingError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateClothingItem(UpdateClothingItem event, Emitter<ClothingState> emit) async {
    if (state is ClothingLoaded) {
      try {
        final updatedItem = await clothingService.updateClothingItem(event.id, event.item);
        final currentState = state as ClothingLoaded;
        final updatedItems = currentState.items.map((item) => item.id == event.id ? updatedItem : item).toList();
        emit(ClothingLoaded(updatedItems, currentState.outfits));
      } catch (e) {
        emit(ClothingError(e.toString()));
      }
    }
  }

  Future<void> _onSaveOutfit(SaveOutfit event, Emitter<ClothingState> emit) async {
    if (state is ClothingLoaded) {
      try {
        final newOutfit = await clothingService.saveOutfit(event.outfit);
        final currentState = state as ClothingLoaded;
        emit(ClothingLoaded(currentState.items, [...currentState.outfits, newOutfit]));
      } catch (e) {
        emit(ClothingError(e.toString()));
      }
    }
  }
}