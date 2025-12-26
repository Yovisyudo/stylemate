import 'package:stylemate/features/event/domain/entities/event.dart';

abstract class EventEvent {}

class LoadEventsEvent extends EventEvent {}

class AddEventEvent extends EventEvent {
  // Gunakan entitas UserEvent agar konsisten dengan UseCase
  final UserEvent event;

  AddEventEvent({required this.event});
}

class DeleteEventEvent extends EventEvent {
  final int eventId;
  DeleteEventEvent(this.eventId);
}
