import 'package:equatable/equatable.dart';

abstract class RecommendationEvent extends Equatable {
  const RecommendationEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk memicu AI agar mulai menganalisis
class GetAiRecommendationEvent extends RecommendationEvent {
  final int eventId;

  const GetAiRecommendationEvent(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

// Event untuk menyimpan outfit yang dipilih user ke MySQL
class SaveSelectedOutfitEvent extends RecommendationEvent {
  final int eventId;
  final List<int> itemIds;

  const SaveSelectedOutfitEvent({required this.eventId, required this.itemIds});

  @override
  List<Object?> get props => [eventId, itemIds];
}
