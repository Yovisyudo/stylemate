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
      appBar: AppBar(title: const Text("AI Stylist Recommendation")),
      body: BlocBuilder<RecommendationBloc, RecommendationState>(
        builder: (context, state) {
          // 1. Tangani State Loading
          if (state is RecommendationLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Gemini sedang memilih outfit terbaik..."),
                ],
              ),
            );
          }

          // 2. Tangani State Loaded
          if (state is RecommendationLoaded) {
            if (state.recommendations.isEmpty) {
              return const Center(
                child: Text(
                  "Baju di lemari tidak ada yang cocok dengan event ini.",
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
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          rec.reason,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          rec.weatherTip,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Divider(height: 30),

                        // REVISI: Tampilan Grid agar item pakaian berdampingan
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // Menampilkan 2 item per baris
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.75,
                                ),
                            itemCount: rec.items.length,
                            itemBuilder: (context, i) {
                              final item = rec.items[i];
                              return Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        item.imageUrl, // ✅ Cukup begini saja, karena URL sudah lengkap dari Data Source
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          // Debugging: Cek apa URL yang error
                                          print(
                                            "Gagal memuat gambar: ${item.imageUrl}",
                                          );
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                              Text(
                                                "No Image",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    item.categoryName ?? 'Kategori Umum',

                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            context.read<RecommendationBloc>().add(
                              SaveSelectedOutfitEvent(
                                eventId: eventId,
                                // Menggunakan .id dari entitas WardrobeItem yang baru
                                itemIds: rec.items.map((e) => e.id).toList(),
                              ), // Hapus titik koma di sini agar tidak error
                            );
                          },
                          child: const Text("Pilih Outfit Ini"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          // 3. Tangani State Error
          if (state is RecommendationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<RecommendationBloc>().add(
                          GetAiRecommendationEvent(eventId),
                        ),
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("Tekan tombol untuk saran AI"));
        },
      ),
    );
  }
}
