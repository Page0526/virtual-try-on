// lib/features/closet/controller/clothing_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/closet/controller/clothing_event.dart';
import 'package:myapp/features/closet/controller/clothing_state.dart';
import 'package:myapp/features/closet/controller/clothing_service.dart';

class ClothingBloc extends Bloc<ClothingEvent, ClothingState> {
  final ClothingService _service;
  String? _currentClosetId;

  ClothingBloc(this._service) : super(ClothingInitial()) {
    on<LoadClothingItems>((event, emit) {
      _currentClosetId = event.closetId;
      emit(ClothingLoading());
      try {
        final items = _service.getItemsForCloset(event.closetId);
        emit(ClothingLoaded(items));
      } catch (e) {
        emit(ClothingError(e.toString()));
      }
    });

    on<AddClothingItem>((event, emit) {
      try {
        _service.addItemToCloset(event.closetId, event.item);
        final items = _service.getItemsForCloset(event.closetId);
        emit(ClothingLoaded(items));
      } catch (e) {
        emit(ClothingError(e.toString()));
      }
    });

    on<UpdateClothingItem>((event, emit) {
      try {
        _service.updateItemInCloset(event.closetId, event.updatedItem);
        final items = _service.getItemsForCloset(event.closetId);
        emit(ClothingLoaded(items));
      } catch (e) {
        emit(ClothingError(e.toString()));
      }
    });

    on<DeleteClothingItem>((event, emit) {
      try {
        _service.removeItemFromCloset(event.closetId, event.itemId);
        final items = _service.getItemsForCloset(event.closetId);
        emit(ClothingLoaded(items));
      } catch (e) {
        emit(ClothingError(e.toString()));
      }
    });
  }
}