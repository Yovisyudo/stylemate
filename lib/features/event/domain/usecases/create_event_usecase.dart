// lib/features/event/domain/usecases/create_event_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:stylemate/features/event/domain/entities/event.dart';
import 'package:stylemate/features/event/domain/repositories/event_repository.dart';
import '../../../../core/error/failures.dart';


class CreateEventUseCase {
  final EventRepository repository;

  CreateEventUseCase(this.repository);

  Future<Either<Failure, void>> call(UserEvent event) async {
    return await repository.createEvent(event);
  }
}
