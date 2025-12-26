import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/event_repository.dart';

class DeleteEventUseCase {
  final EventRepository repository;

  DeleteEventUseCase(this.repository);

  Future<Either<Failure, void>> call(int eventId) async {
    return await repository.deleteEvent(eventId);
  }
}
