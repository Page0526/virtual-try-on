// lib/features/fitting_room/controller/try_on_state.dart
import 'dart:io';

abstract class TryOnState {
  final int currentStep;
  final File? clothImage;
  final File? personImage;

  TryOnState({
    this.currentStep = 0,
    this.clothImage,
    this.personImage,
  });
}

class TryOnInitial extends TryOnState {
  TryOnInitial() : super(currentStep: 0, clothImage: null, personImage: null);
}

class TryOnLoading extends TryOnState {
  TryOnLoading({
    required int currentStep,
    File? clothImage,
    File? personImage,
  }) : super(currentStep: currentStep, clothImage: clothImage, personImage: personImage);
}

class TryOnSuccess extends TryOnState {
  final List<int> resultImageBytes;

  TryOnSuccess({
    required this.resultImageBytes,
    required int currentStep,
    File? clothImage,
    File? personImage,
  }) : super(currentStep: currentStep, clothImage: clothImage, personImage: personImage);
}

class TryOnFailure extends TryOnState {
  final String error;

  TryOnFailure({
    required this.error,
    required int currentStep,
    File? clothImage,
    File? personImage,
  }) : super(currentStep: currentStep, clothImage: clothImage, personImage: personImage);
}