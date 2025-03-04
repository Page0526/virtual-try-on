// lib/features/closet/controller/outfit_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/closet/controller/outfit_event.dart';
import 'package:myapp/features/closet/controller/outfit_state.dart';
import 'package:myapp/features/closet/controller/outfit_service.dart';

class OutfitBloc extends Bloc<OutfitEvent, OutfitState> {
  final OutfitService _service;

  OutfitBloc(this._service) : super(OutfitInitial()) {
    on<LoadOutfitCategories>((event, emit) {
      emit(OutfitLoading());
      try {
        final categories = _service.getAllCategories();
        emit(OutfitCategoriesLoaded(categories));
      } catch (e) {
        emit(OutfitError(e.toString()));
      }
    });

    on<LoadOutfitsByCategory>((event, emit) {
      emit(OutfitLoading());
      try {
        final outfits = _service.getOutfitsByCategory(event.categoryId);
        emit(OutfitsByCategoryLoaded(event.categoryId, outfits));
      } catch (e) {
        emit(OutfitError(e.toString()));
      }
    });

    on<AddOutfit>((event, emit) {
      try {
        _service.addOutfit(event.outfit);
        if (state is OutfitCategoriesLoaded) {
          final categories = (state as OutfitCategoriesLoaded).categories;
          emit(OutfitCategoriesLoaded(categories));
        }
      } catch (e) {
        emit(OutfitError(e.toString()));
      }
    });

    on<AddOutfitWithImage>((event, emit) async {
      try {
        final updatedOutfit = await _service.addOutfitWithImage(event.outfit, event.imageBytes);
        if (state is OutfitCategoriesLoaded) {
          final categories = (state as OutfitCategoriesLoaded).categories;
          emit(OutfitCategoriesLoaded(categories));
        }
      } catch (e) {
        emit(OutfitError(e.toString()));
      }
    });

    on<UpdateOutfit>((event, emit) {
      try {
        _service.updateOutfit(event.updatedOutfit);
        if (state is OutfitCategoriesLoaded) {
          final categories = (state as OutfitCategoriesLoaded).categories;
          emit(OutfitCategoriesLoaded(categories));
        }
      } catch (e) {
        emit(OutfitError(e.toString()));
      }
    });

    on<DeleteOutfit>((event, emit) {
      try {
        _service.deleteOutfit(event.outfitId);
        if (state is OutfitCategoriesLoaded) {
          final categories = (state as OutfitCategoriesLoaded).categories;
          emit(OutfitCategoriesLoaded(categories));
        }
      } catch (e) {
        emit(OutfitError(e.toString()));
      }
    });

    on<AddItemToOutfit>((event, emit) {
      try {
        _service.addItemToOutfit(event.outfitId, event.item);
        if (state is OutfitsByCategoryLoaded) {
          final currentState = state as OutfitsByCategoryLoaded;
          final outfits = _service.getOutfitsByCategory(currentState.categoryId);
          emit(OutfitsByCategoryLoaded(currentState.categoryId, outfits));
        }
      } catch (e) {
        emit(OutfitError(e.toString()));
      }
    });

    on<RemoveItemFromOutfit>((event, emit) {
      try {
        _service.removeItemFromOutfit(event.outfitId, event.itemId);
        if (state is OutfitsByCategoryLoaded) {
          final currentState = state as OutfitsByCategoryLoaded;
          final outfits = _service.getOutfitsByCategory(currentState.categoryId);
          emit(OutfitsByCategoryLoaded(currentState.categoryId, outfits));
        }
      } catch (e) {
        emit(OutfitError(e.toString()));
      }
    });
  }
}