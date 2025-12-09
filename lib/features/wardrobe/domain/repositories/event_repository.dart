import 'package:dartz/dartz.dart';
import 'package:stylemate/features/auth/domain/entities/event.dart';
import '../../../../core/error/failures.dart';


abstract class EventRepository {
  Future<Either<Failure, List<Event>>> getEvents();
  Future<Either<Failure, Event>> createEvent(Event event);
  Future<Either<Failure, void>> deleteEvent(int eventId);
}
