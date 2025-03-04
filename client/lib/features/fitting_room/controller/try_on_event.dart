// lib/features/fitting_room/controller/try_on_event.dart
import 'dart:io';

abstract class TryOnEvent {}

class SelectClothImage extends TryOnEvent {
  final File clothImage;
  SelectClothImage(this.clothImage);
}

class SelectPersonImage extends TryOnEvent {
  final File personImage;
  SelectPersonImage(this.personImage);
}

class TryOnRequested extends TryOnEvent {
  final File personImage;
  final File clothImage;
  TryOnRequested({required this.personImage, required this.clothImage});
}

class ResetTryOn extends TryOnEvent {}