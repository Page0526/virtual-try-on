// lib/features/closet/controller/outfit_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/closet/controller/outfit_event.dart';
import 'package:myapp/features/closet/controller/outfit_service.dart';
import 'package:myapp/features/closet/controller/outfit_state.dart';

class OutfitBloc extends Bloc<OutfitEvent, OutfitState> {
  final OutfitService outfitService;

  OutfitBloc(this.outfitService) : super(OutfitInitial()) {
    on<LoadOutfits>((event, emit) async {
      emit(OutfitLoading());
      try {
        final outfits = await outfitService.getOutfits();
        emit(OutfitLoaded(outfits));
      } catch (e) {
        emit(OutfitError(e.toString()));
      }
    });

    on<AddOutfitWithImage>((event, emit) async {
      try {
        await outfitService.addOutfit(event.outfit, event.imageBytes);
        final outfits = await outfitService.getOutfits();
        emit(OutfitLoaded(outfits));
      } catch (e) {
        emit(OutfitError(e.toString()));
      }
    });
  }
}