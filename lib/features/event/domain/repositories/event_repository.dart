// lib/features/event/domain/repositories/event_repository.dart

import 'package:dartz/dartz.dart';
import 'package:stylemate/features/event/domain/entities/event.dart';
import '../../../../core/error/failures.dart';

abstract class EventRepository {
  Future<Either<Failure, List<UserEvent>>> getEvents();
  Future<Either<Failure, void>> createEvent(UserEvent event);
  Future<Either<Failure, void>> deleteEvent(int eventId);
}
