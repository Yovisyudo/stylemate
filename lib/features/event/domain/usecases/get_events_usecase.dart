import 'package:dartz/dartz.dart';
import 'package:stylemate/features/auth/domain/entities/event.dart';
import '../../../../core/error/failures.dart';

import '../../../wardrobe/domain/repositories/event_repository.dart';

class GetEventsUseCase {
  final EventRepository repository;

  GetEventsUseCase(this.repository);

  Future<Either<Failure, List<Event>>> call() async {
    return await repository.getEvents();
  }
}
