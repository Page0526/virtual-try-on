// lib/features/closet/controller/closet_service.dart
import 'package:myapp/features/closet/model/closet.dart';

class ClosetService {
  final Map<String, Closet> _closets = {
    '1': const Closet(id: '1', name: 'All clothes', items: []),
  };

  List<Closet> getAllClosets() => _closets.values.toList();

  Closet? getClosetById(String id) => _closets[id];

  void addCloset(Closet closet) {
    _closets[closet.id] = closet;
  }

  void updateCloset(Closet updatedCloset) {
    if (_closets.containsKey(updatedCloset.id)) {
      _closets[updatedCloset.id] = updatedCloset;
    }
  }

  void deleteCloset(String closetId) {
    _closets.remove(closetId);
  }
}