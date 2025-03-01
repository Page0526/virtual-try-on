// lib/business_logic/bloc/try_on_state.dart
import 'package:equatable/equatable.dart';

abstract class TryOnState extends Equatable {
  const TryOnState();

  @override
  List<Object> get props => [];
}

class TryOnInitial extends TryOnState {}

class TryOnLoading extends TryOnState {}

class TryOnSuccess extends TryOnState {
  final List<int> resultImageBytes; // Dữ liệu ảnh dưới dạng List<int>

  const TryOnSuccess(this.resultImageBytes);

  @override
  List<Object> get props => [resultImageBytes];
}

class TryOnFailure extends TryOnState {
  final String error;

  const TryOnFailure(this.error);

  @override
  List<Object> get props => [error];
}