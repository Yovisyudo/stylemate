
abstract class EventEvent {}

class LoadEventsEvent extends EventEvent {}

class CreateEventEvent extends EventEvent {
  final String name;
  final String description;
  final DateTime date;
  final String location;
  
  CreateEventEvent({
    required this.name,
    required this.description,
    required this.date,
    required this.location,
  });
}