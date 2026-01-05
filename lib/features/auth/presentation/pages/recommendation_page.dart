import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_event.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_state.dart';

class RecommendationPage extends StatelessWidget {
  final int eventId;

  const RecommendationPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Stylist Recommendation'),
        centerTitle: true,
      ),
      body: BlocBuilder<RecommendationBloc, RecommendationState>(
        builder: (context, state) {
          /// =========================
          /// LOADING
          /// =========================
          if (state is RecommendationLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'AI sedang memilih outfit terbaik...',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          /// =========================
          /// LOADED
          /// =========================
          if (state is RecommendationLoaded) {
            if (state.recommendations.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada outfit yang cocok untuk event ini.',
                  textAlign: TextAlign.center,
                ),
              );
            }

            return PageView.builder(
              itemCount: state.recommendations.length,
              itemBuilder: (context, index) {
                final rec = state.recommendations[index];

                return Card(
                  margin: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        /// ===== Reason
                        Text(
                          rec.reason,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// ===== Weather Tip
                        if (rec.weatherTip.isNotEmpty)
                          Text(
                            rec.weatherTip,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        const Divider(height: 32),

                        /// ===== Items Grid
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.75,
                                ),
                            itemCount: rec.items.length,
                            itemBuilder: (context, i) {
                              final item = rec.items[i];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        item.image,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.categoryName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// ===== Save Outfit Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            context.read<RecommendationBloc>().add(
                              SaveSelectedOutfitEvent(
                                eventId: eventId,
                                itemIds: rec.items.map((e) => e.id).toList(),
                              ),
                            );
                          },
                          child: const Text('Pilih Outfit Ini'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          /// =========================
          /// ERROR
          /// =========================
          if (state is RecommendationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RecommendationBloc>().add(
                        GetAiRecommendationEvent(eventId),
                      );
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          /// =========================
          /// DEFAULT
          /// =========================
          return const Center(child: Text('Menunggu rekomendasi AI...'));
        },
      ),
    );
  }
}
