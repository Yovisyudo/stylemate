// lib/features/event/presentation/bloc/event_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/event/domain/usecases/delete_event_usecase.dart';
import '../../domain/usecases/get_events_usecase.dart';
import '../../domain/usecases/create_event_usecase.dart'; // Tambahkan ini
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventsUseCase getEventsUseCase;
  final CreateEventUseCase createEventUseCase;
  final DeleteEventUseCase deleteEventUseCase; // Tambahkan ini

  EventBloc({
    required this.getEventsUseCase,
    required this.createEventUseCase,
    required this.deleteEventUseCase,
  }) : super(EventInitial()) {
    on<LoadEventsEvent>(_onLoadEvents);
    on<AddEventEvent>(_onAddEvent);
    on<DeleteEventEvent>(
      _onDeleteEvent,
    ); // Daftarkan handler untuk tambah event
  }

  Future<void> _onLoadEvents(
    LoadEventsEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());

    final result = await getEventsUseCase();

    result.fold(
      (failure) => emit(EventError(message: failure.message)),
      (events) => emit(EventLoaded(events: events)),
    );
  }

  // Handler baru untuk tambah event
  Future<void> _onAddEvent(
    AddEventEvent event,
    Emitter<EventState> emit,
  ) async {
    // Kita tetap di state yang ada atau bisa emit loading khusus
    final result = await createEventUseCase(event.event);

    // event_bloc.dart
    result.fold((failure) => emit(EventError(message: failure.message)), (_) {
      // HAPUS 'const' di sini karena LoadEventsEvent mungkin bukan constructor const
      add(LoadEventsEvent());
    });
  }

  Future<void> _onDeleteEvent(
    DeleteEventEvent event,
    Emitter<EventState> emit,
  ) async {
    // GUNAKAN variabel instance 'deleteEventUseCase' yang ada di property class
    final result = await deleteEventUseCase(event.eventId);

    result.fold(
      (failure) => emit(EventError(message: failure.message)),
      // Setelah berhasil hapus di MySQL, panggil LoadEventsEvent untuk refresh UI
      (_) => add(LoadEventsEvent()),
    );
  }
}
