

import 'package:stylemate/features/auth/domain/entities/event.dart';

abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<Event> events;
  
  EventLoaded({required this.events});
}

class EventError extends EventState {
  final String message;
  
  EventError({required this.message});
}