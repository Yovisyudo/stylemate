import 'package:stylemate/features/event/domain/entities/event.dart';

// Import entitas yang benar

abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  // Menggunakan List UserEvent sesuai output GetEventsUseCase
  final List<UserEvent> events;

  EventLoaded({required this.events});
}

class EventError extends EventState {
  final String message;

  EventError({required this.message});
}

// Tambahkan state sukses untuk memberi feedback saat berhasil tambah event
class EventCreateSuccess extends EventState {}
