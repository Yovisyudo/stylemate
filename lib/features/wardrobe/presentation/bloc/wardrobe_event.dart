

import 'package:stylemate/features/wardrobe/domain/entities/wardrobe_item.dart';

abstract class WardrobeEvent {}

class LoadWardrobeEvent extends WardrobeEvent {}

class AddItemEvent extends WardrobeEvent {
  final WardrobeItem item;
  
  AddItemEvent(this.item);
}