// lib/business_logic/bloc/try_on_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/business_logic/blocs/try_on/try_on_event.dart';
import 'package:myapp/business_logic/blocs/try_on/try_on_state.dart';
import 'package:myapp/data/services/try_on_service.dart';

class TryOnBloc extends Bloc<TryOnEvent, TryOnState> {
  final TryOnService tryOnService;

  TryOnBloc(this.tryOnService) : super(TryOnInitial()) {
    on<TryOnRequested>((event, emit) async {
      emit(TryOnLoading());
      try {
        final resultImageBytes = await tryOnService.tryOn(
          event.personImage,
          event.clothImage,
        );
        emit(TryOnSuccess(resultImageBytes));
      } catch (e) {
        emit(TryOnFailure(e.toString()));
      }
    });
  }
}