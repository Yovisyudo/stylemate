


import 'package:stylemate/features/auth/presentation/pages/wardrobe_item.dart';

abstract class WardrobeState {}

class WardrobeInitial extends WardrobeState {}

class WardrobeLoading extends WardrobeState {}

class WardrobeLoaded extends WardrobeState {
  final List<WardrobeItem> items;
  
  WardrobeLoaded({required this.items});
}

class WardrobeError extends WardrobeState {
  final String message;
  
  WardrobeError({required this.message});
}
