
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/event/domain/usecases/get_events_usecase.dart';

import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventsUseCase getEventsUseCase;

  EventBloc({required this.getEventsUseCase}) : super(EventInitial()) {
    on<LoadEventsEvent>(_onLoadEvents);
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
}