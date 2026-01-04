import 'package:dartz/dartz.dart';
import 'package:stylemate/features/auth/domain/entities/recommendation.dart';
import '../../../../core/error/failures.dart';

abstract class RecommendationRepository {
  Future<Either<Failure, List<Recommendation>>> getAiRecommendations(
    int eventId,
  );

  Future<Either<Failure, void>> saveOutfit(
    int eventId,
    List<int> itemIds,
  );
}
