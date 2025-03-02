// lib/business_logic/bloc/try_on_event.dart
import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class TryOnEvent extends Equatable {
  const TryOnEvent();

  @override
  List<Object> get props => [];
}

class TryOnRequested extends TryOnEvent {
  final File personImage;
  final File clothImage;

  const TryOnRequested({required this.personImage, required this.clothImage});

  @override
  List<Object> get props => [personImage, clothImage];
}