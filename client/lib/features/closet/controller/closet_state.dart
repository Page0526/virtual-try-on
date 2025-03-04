// lib/features/closet/controller/closet_state.dart
import 'package:myapp/features/closet/model/closet.dart';

abstract class ClosetState {}

class ClosetInitial extends ClosetState {}

class ClosetLoading extends ClosetState {}

class ClosetLoaded extends ClosetState {
  final List<Closet> closets;
  ClosetLoaded(this.closets);
}

class ClosetError extends ClosetState {
  final String message;
  ClosetError(this.message);
}