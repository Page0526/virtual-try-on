// lib/features/closet/controller/closet_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/closet/controller/closet_event.dart';
import 'package:myapp/features/closet/controller/closet_state.dart';
import 'package:myapp/features/closet/controller/closet_service.dart';

class ClosetBloc extends Bloc<ClosetEvent, ClosetState> {
  final ClosetService _service;

  ClosetBloc(this._service) : super(ClosetInitial()) {
    on<LoadClosets>((event, emit) {
      emit(ClosetLoading());
      try {
        final closets = _service.getAllClosets();
        emit(ClosetLoaded(closets));
      } catch (e) {
        emit(ClosetError(e.toString()));
      }
    });

    on<AddCloset>((event, emit) {
      try {
        _service.addCloset(event.closet);
        emit(ClosetLoaded(_service.getAllClosets()));
      } catch (e) {
        emit(ClosetError(e.toString()));
      }
    });

    on<UpdateCloset>((event, emit) {
      try {
        _service.updateCloset(event.updatedCloset);
        emit(ClosetLoaded(_service.getAllClosets()));
      } catch (e) {
        emit(ClosetError(e.toString()));
      }
    });

    on<DeleteCloset>((event, emit) {
      try {
        _service.deleteCloset(event.closetId);
        emit(ClosetLoaded(_service.getAllClosets()));
      } catch (e) {
        emit(ClosetError(e.toString()));
      }
    });
  }
}