import 'package:equatable/equatable.dart';
import 'package:stylemate/features/wardrobe/domain/entities/wardrobe_item.dart';

abstract class WardrobeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WardrobeInitial extends WardrobeState {}

class WardrobeLoading extends WardrobeState {}

class WardrobeLoaded extends WardrobeState {
  final List<WardrobeItem> items;
  WardrobeLoaded({required this.items});

  @override
  List<Object?> get props => [items]; // UI akan rebuild jika list item berubah
}

class WardrobeError extends WardrobeState {
  final String message;
  WardrobeError({required this.message});

  @override
  List<Object?> get props => [message];
}
