import 'package:dartz/dartz.dart';
import 'package:stylemate/features/auth/data/repositories/recommendation_repository.dart';
import '../../../../core/error/failures.dart';
import '../datasources/recommendation_remote_data_source.dart';
import '../../domain/entities/recommendation.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationRemoteDataSource remoteDataSource;
  RecommendationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Recommendation>>> getAiRecommendations(
    int eventId,
  ) async {
    try {
      final result = await remoteDataSource.getRecommendations(eventId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveOutfit(
    int eventId,
    List<int> itemIds,
  ) async {
    try {
      await remoteDataSource.saveOutfit(eventId, itemIds);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
