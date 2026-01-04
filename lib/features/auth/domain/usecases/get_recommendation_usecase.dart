// lib/features/recommendation/domain/usecases/get_recommendation_usecase.dart

import 'package:dartz/dartz.dart'; // Pastikan ini ada
import 'package:stylemate/features/auth/data/repositories/recommendation_repository.dart';
import '../entities/recommendation.dart';
import '../../../../core/error/failures.dart';

class GetRecommendationsUseCase {
  final RecommendationRepository repository;
  GetRecommendationsUseCase(this.repository);

  // Pastikan tipe return sesuai dengan interface repository
  Future<Either<Failure, List<Recommendation>>> call(int eventId) async {
    return await repository.getAiRecommendations(eventId);
  }
}
