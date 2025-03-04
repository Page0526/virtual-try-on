// lib/features/closet/controller/closet_event.dart
import 'package:myapp/features/closet/model/closet.dart';

abstract class ClosetEvent {}

class LoadClosets extends ClosetEvent {}

class AddCloset extends ClosetEvent {
  final Closet closet;
  AddCloset(this.closet);
}

class UpdateCloset extends ClosetEvent {
  final Closet updatedCloset;
  UpdateCloset(this.updatedCloset);
}

class DeleteCloset extends ClosetEvent {
  final String closetId;
  DeleteCloset(this.closetId);
}