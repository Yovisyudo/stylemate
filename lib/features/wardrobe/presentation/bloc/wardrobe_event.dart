import 'package:stylemate/features/wardrobe/domain/entities/wardrobe_item.dart';

abstract class WardrobeEvent {
  const WardrobeEvent();
}

class LoadWardrobeEvent extends WardrobeEvent {
  const LoadWardrobeEvent();
}

class AddItemEvent extends WardrobeEvent {
  final Map<String, dynamic> item;

  const AddItemEvent({required this.item});
}

class UpdateWardrobeEvent extends WardrobeEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateWardrobeEvent({required this.id, required this.data});
}

class DeleteWardrobeEvent extends WardrobeEvent {
  final int id;

  const DeleteWardrobeEvent({required this.id});
}
