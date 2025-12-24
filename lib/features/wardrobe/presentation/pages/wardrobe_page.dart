import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylemate/features/wardrobe/presentation/pages/add_wardrobe_page.dart';
import '../bloc/wardrobe_bloc.dart';
import '../bloc/wardrobe_event.dart';
import '../bloc/wardrobe_state.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  @override
  void initState() {
    super.initState();
    // Memanggil data saat halaman dibuka
    context.read<WardrobeBloc>().add(LoadWardrobeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'My Wardrobe',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {}, // Fitur filter kategori
          ),
        ],
      ),
      body: BlocBuilder<WardrobeBloc, WardrobeState>(
        builder: (context, state) {
          if (state is WardrobeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WardrobeLoaded) {
            if (state.items.isEmpty) {
              return _buildEmptyState();
            }
            return _buildWardrobeGrid(state.items);
          } else if (state is WardrobeError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWardrobePage()),
          ); // Navigasi ke halaman tambah baju (AddWardrobePage)
        },
        label: const Text('Add Item'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checkroom, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            "No items yet. Start adding your style!",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildWardrobeGrid(items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom agar terlihat modern
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75, // Mengatur tinggi card
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Gambar
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child:
                      item.imageUrl != null
                          ? Image.network(
                            item.imageUrl!, // URL dari backend CI4
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder:
                                (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.broken_image),
                                ),
                          )
                          : const Center(child: Icon(Icons.image, size: 50)),
                ),
              ),
              // Bagian Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.categoryName ?? 'Uncategorized', // Hasil JOIN CI4
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color:
                                Colors
                                    .blue, // Bisa diganti sesuai variabel color item
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.style ?? 'Casual',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
