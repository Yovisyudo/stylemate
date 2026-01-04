import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_event.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_state.dart';
import '../../domain/usecases/get_recommendation_usecase.dart';
// Tambahkan event & state classes di file terpisah biasanya, ini versi ringkas:

class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  final GetRecommendationsUseCase getRecommendationsUseCase;

  RecommendationBloc({required this.getRecommendationsUseCase})
    : super(RecommendationInitial()) {
    on<GetAiRecommendationEvent>((event, emit) async {
      emit(RecommendationLoading());
      final result = await getRecommendationsUseCase(event.eventId);
      result.fold(
        (failure) => emit(RecommendationError(failure.message)),
        (data) => emit(RecommendationLoaded(data)),
      );
    });
  }
}
