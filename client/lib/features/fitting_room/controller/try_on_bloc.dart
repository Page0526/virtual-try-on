// lib/features/fitting_room/controller/try_on_bloc.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/fitting_room/controller/try_on_event.dart';
import 'package:myapp/features/fitting_room/controller/try_on_state.dart';
import 'package:myapp/features/fitting_room/controller/try_on_service.dart';

class TryOnBloc extends Bloc<TryOnEvent, TryOnState> {
  final TryOnService service;

  TryOnBloc(this.service) : super(TryOnInitial()) {
    on<SelectClothImage>((event, emit) {
      emit(TryOnInitial().copyWith(
        currentStep: 0,
        clothImage: event.clothImage,
      ));
    });

    on<SelectPersonImage>((event, emit) {
      emit(state.copyWith(
        currentStep: 1,
        personImage: event.personImage,
      ));
    });

    on<TryOnRequested>((event, emit) async {
      emit(TryOnLoading(
        currentStep: state.currentStep,
        clothImage: state.clothImage,
        personImage: state.personImage,
      ));

      try {
        final resultImageBytes = await service.tryOn(event.personImage, event.clothImage);
        emit(TryOnSuccess(
          resultImageBytes: resultImageBytes,
          currentStep: state.currentStep,
          clothImage: state.clothImage,
          personImage: state.personImage,
        ));
      } catch (e) {
        emit(TryOnFailure(
          error: e.toString(),
          currentStep: state.currentStep,
          clothImage: state.clothImage,
          personImage: state.personImage,
        ));
      }
    });

    on<ResetTryOn>((event, emit) {
      emit(TryOnInitial());
    });
  }
}

extension TryOnStateExtension on TryOnState {
  TryOnState copyWith({
    int? currentStep,
    File? clothImage,
    File? personImage,
  }) {
    if (this is TryOnInitial) {
      return TryOnInitial().copyWith(
        currentStep: currentStep ?? this.currentStep,
        clothImage: clothImage ?? this.clothImage,
        personImage: personImage ?? this.personImage,
      );
    } else if (this is TryOnLoading) {
      return TryOnLoading(
        currentStep: currentStep ?? this.currentStep,
        clothImage: clothImage ?? this.clothImage,
        personImage: personImage ?? this.personImage,
      );
    } else if (this is TryOnSuccess) {
      return TryOnSuccess(
        resultImageBytes: (this as TryOnSuccess).resultImageBytes,
        currentStep: currentStep ?? this.currentStep,
        clothImage: clothImage ?? this.clothImage,
        personImage: personImage ?? this.personImage,
      );
    } else if (this is TryOnFailure) {
      return TryOnFailure(
        error: (this as TryOnFailure).error,
        currentStep: currentStep ?? this.currentStep,
        clothImage: clothImage ?? this.clothImage,
        personImage: personImage ?? this.personImage,
      );
    }
    return this;
  }
}