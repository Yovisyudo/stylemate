import 'package:dartz/dartz.dart';
import 'package:stylemate/features/event/data/datasources/event_remote_data_source.dart';
import 'package:stylemate/features/event/data/models/event_models.dart';
import 'package:stylemate/features/event/domain/entities/event.dart';
import 'package:stylemate/features/event/domain/repositories/event_repository.dart';
import '../../../../core/error/failures.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserEvent>>> getEvents() async {
    try {
      final remoteEvents = await remoteDataSource.getEvents();
      return Right(remoteEvents);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createEvent(UserEvent event) async {
    try {
      final eventModel = EventModel(
        id: event.id,
        name: event.name,
        description: event.description,
        date: event.date,
        location: event.location,
        weatherTemp: event.weatherTemp,
        weatherCondition: event.weatherCondition,
      );

      await remoteDataSource.createEvent(eventModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // TAMBAHKAN IMPLEMENTASI METODE INI UNTUK MENGHILANGKAN ERROR:
  @override
  Future<Either<Failure, void>> deleteEvent(int eventId) async {
    try {
      // Memanggil fungsi delete di Remote Data Source
      await remoteDataSource.deleteEvent(eventId);
      return const Right(null);
    } catch (e) {
      // Menangkap error jika gagal menghapus di MySQL
      return Left(ServerFailure(e.toString()));
    }
  }
}
