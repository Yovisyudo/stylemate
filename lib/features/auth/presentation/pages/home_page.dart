import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/auth_state.dart';
// ADDED: Import ProfileBloc agar nama bisa update real-time
import 'package:stylemate/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:stylemate/features/event/presentation/bloc/event_bloc.dart';
import 'package:stylemate/features/event/presentation/bloc/event_state.dart';
import 'package:stylemate/features/event/presentation/bloc/event_event.dart';
import 'package:stylemate/features/profile/presentation/pages/profile_page.dart';
import 'package:stylemate/features/wardrobe/presentation/bloc/wardrobe_bloc.dart';
import 'package:stylemate/features/wardrobe/presentation/bloc/wardrobe_event.dart';
import 'package:stylemate/features/wardrobe/presentation/bloc/wardrobe_state.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_bloc.dart';
import 'package:stylemate/features/auth/presentation/bloc/recommendation_event.dart';
import 'package:stylemate/features/auth/presentation/pages/recommendation_page.dart';
import 'package:stylemate/features/wardrobe/presentation/pages/wardrobe_page.dart';
import 'package:stylemate/features/event/presentation/pages/event_page.dart';

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
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF4D61F4),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            context.read<EventBloc>().add(LoadEventsEvent());
            context.read<WardrobeBloc>().add(const LoadWardrobeEvent());
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: "Lemari",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: "AI Recommend",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Event"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    context.read<EventBloc>().add(LoadEventsEvent());
    context.read<WardrobeBloc>().add(const LoadWardrobeEvent());

    return BlocBuilder<EventBloc, EventState>(
      builder: (context, eventState) {
        return BlocBuilder<WardrobeBloc, WardrobeState>(
          builder: (context, wardrobeState) {
            if (eventState is EventLoading ||
                wardrobeState is WardrobeLoading) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: Lottie.network(
                          'https://lottie.host/bee9c3eb-5676-46cf-8ef7-5d24d9f8528a/rGRZcJ9H89.json',
                          repeat: false,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              ),
                            );
                          },
                          frameBuilder: (context, child, composition) {
                            return composition == null
                                ? const Center(
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                  ),
                                )
                                : child;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "StyleMate",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _combinedHeaderCard(context, eventState, wardrobeState),
                    const SizedBox(height: 20),
                    const Text(
                      "Acara Mendatang",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (eventState is EventLoaded)
                      ...eventState.events.map(
                        (event) => _eventCard(context, event),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _combinedHeaderCard(
    BuildContext context,
    EventState eventState,
    WardrobeState wardrobeState,
  ) {
    int itemCount =
        (wardrobeState is WardrobeLoaded) ? wardrobeState.items.length : 0;
    int eventCount = (eventState is EventLoaded) ? eventState.events.length : 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF4D61F4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FIXED: Menggunakan ProfileBloc agar nama langsung berubah setelah diedit
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String name = "User";

              if (state is ProfileLoaded) {
                // Ambil nama terbaru dari ProfileBloc
                name = state.user.name;
              } else {
                // Fallback ke AuthBloc jika ProfileBloc belum load
                final authState = context.read<AuthBloc>().state;
                if (authState is AuthAuthenticated) {
                  name = authState.name; // Langsung panggil .name
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hai, $name!", // Akan otomatis update
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Apa outfit hari ini?",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _statItem("Total Items", itemCount.toString())),
              Expanded(child: _statItem("Acara", eventCount.toString())),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _eventCard(BuildContext context, dynamic event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4D61F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "${event.weatherTemp ?? '--'}°C",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                context.read<RecommendationBloc>().add(
                  GetAiRecommendationEvent(event.id),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecommendationPage(eventId: event.id),
                  ),
                );
              },
              child: const Text(
                "Get AI Recommendation",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
