// lib/business_logic/bloc/outfit_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart'; // Import từ flutter_bloc
import 'package:myapp/data/services/outfit_service.dart';
import 'outfit_event.dart';
import 'outfit_state.dart';

class OutfitBloc extends Bloc<OutfitEvent, OutfitState> {
  final OutfitService outfitService;

  OutfitBloc(this.outfitService) : super(OutfitInitial()) {
    on<GetOutfitSuggestions>(_onGetOutfitSuggestions);
  }

  Future<void> _onGetOutfitSuggestions(
    GetOutfitSuggestions event,
    Emitter<OutfitState> emit,
  ) async {
    emit(OutfitLoading());
    try {
      final outfits = await outfitService.getOutfitSuggestions(event.itemId, event.occasion);
      emit(OutfitLoaded(outfits));
    } catch (e) {
      emit(OutfitError(e.toString()));
    }
  }
}