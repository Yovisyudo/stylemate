import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Menangani ralat context.read
import 'package:stylemate/features/auth/presentation/bloc/recommendation_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_event.dart';
import 'package:stylemate/features/auth/presentation/pages/recommendation_page.dart';
import 'package:stylemate/features/event/domain/usecases/get_events_usecase.dart';

// IMPORT FITUR REKOMENDASI (Clean Architecture)

// IMPORT FITUR EVENT (Untuk Data Dinamis)
import 'package:stylemate/features/event/presentation/bloc/event_bloc.dart';
import 'package:stylemate/features/event/presentation/bloc/event_state.dart';
import 'package:stylemate/features/event/presentation/bloc/event_event.dart';
import 'package:stylemate/features/event/presentation/pages/event_page.dart';

// IMPORT FITUR LAIN
import 'package:stylemate/features/wardrobe/presentation/pages/wardrobe_page.dart';

class StyleMateHome extends StatefulWidget {
  const StyleMateHome({super.key});

  @override
  State<StyleMateHome> createState() => _StyleMateHomeState();
}

class _StyleMateHomeState extends State<StyleMateHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const WardrobePage(),
    const RecommendationPage(eventId: 0),
    const EventPage(),
    const Center(child: Text("Profile Page")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: "Lemari"),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome),
          label: "AI Recommend",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: "Event"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    // Memicu pengambilan data event saat Beranda dibuka
    // ✅ BENAR
    context.read<EventBloc>().add(LoadEventsEvent());

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "StyleMate",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _headerCard(),
            const SizedBox(height: 20),
            const Text(
              "Acara Mendatang",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // REVISI: Mengambil data dinamis menggunakan BlocBuilder
            BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EventLoaded) {
                  if (state.events.isEmpty) {
                    return const Text("Tidak ada acara dalam waktu dekat.");
                  }
                  return Column(
                    children:
                        state.events.map((event) {
                          return _eventCard(
                            context,
                            event.name, // Sesuai dengan getter model UserEvent
                            event.date.toString(),
                            "${event.weatherTemp}°", // Sesuai dengan getter model UserEvent
                            event.id, // Sesuai dengan getter model UserEvent
                          );
                        }).toList(),
                  );
                }
                return const Text("Gagal memuat data event.");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffAEC9FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _InfoBox(title: "Items", value: "12"),
          _InfoBox(title: "Events", value: "4"),
        ],
      ),
    );
  }

  Widget _eventCard(
    BuildContext context,
    String title,
    String date,
    String temp,
    int eventId,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffD8E3FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("$date | $temp"),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade100,
                foregroundColor: Colors.purple.shade900,
              ),
              onPressed: () {
                // PERBAIKAN SINTAKSIS: Menghapus titik koma di dalam parameter
                context.read<RecommendationBloc>().add(
                  GetAiRecommendationEvent(eventId),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecommendationPage(eventId: eventId),
                  ),
                );
              },
              child: const Text("Get AI Recommendation"),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;
  const _InfoBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
