import 'package:equatable/equatable.dart';
import '../../domain/entities/recommendation.dart';

abstract class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object?> get props => [];
}

// 1. State Awal (Saat halaman baru dibuka)
class RecommendationInitial extends RecommendationState {}

// 2. State Loading (Saat sedang menunggu respon dari Gemini API)
class RecommendationLoading extends RecommendationState {}

// 3. State Sukses (Saat 3 pilihan outfit berhasil diterima dari backend)
class RecommendationLoaded extends RecommendationState {
  final List<Recommendation> recommendations;

  const RecommendationLoaded(this.recommendations);

  @override
  List<Object?> get props => [recommendations];
}

// 4. State Error (Saat koneksi gagal atau API Gemini bermasalah)
class RecommendationError extends RecommendationState {
  final String message;

  const RecommendationError(this.message);

  @override
  List<Object?> get props => [message];
}

// 5. State Sukses Simpan (Opsional, saat user menekan tombol 'Save Outfit')
class OutfitSavedSuccess extends RecommendationState {
  final String message;

  const OutfitSavedSuccess(this.message);

  @override
  List<Object?> get props => [message];
}