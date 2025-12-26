// lib/features/event/presentation/pages/event_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stylemate/features/event/presentation/pages/add_event.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../../../../core/utils/weather_helper.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  void initState() {
    super.initState();
    // Memuat data event saat halaman dibuka
    context.read<EventBloc>().add(LoadEventsEvent());
  }

  // FUNGSI BARU: Menampilkan dialog konfirmasi hapus
  void _showDeleteDialog(BuildContext context, int eventId) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text("Delete Event?"),
            content: const Text("Are you sure you want to remove this event?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  // Mengirim event delete ke BLoC
                  context.read<EventBloc>().add(DeleteEventEvent(eventId));
                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Processing delete...")),
                  );
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Events",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined),
          ),
        ],
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventLoaded) {
            if (state.events.isEmpty) {
              return const Center(child: Text("No Events Found"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                final weatherColor = WeatherHelper.getWeatherColor(
                  event.weatherCondition,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              event.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: Colors.purpleAccent,
                            ),
                          ],
                        ),
                        Text(
                          event.description,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            Text(
                              " ${event.location}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: weatherColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                WeatherHelper.getWeatherIcon(
                                  event.weatherCondition,
                                ),
                                color: weatherColor,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "${event.weatherTemp ?? '--'}°C",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(event.weatherCondition ?? "Unknown"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // REVISI: Penambahan Tombol Delete
                            TextButton.icon(
                              onPressed:
                                  () => _showDeleteDialog(context, event.id),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 18,
                              ),
                              label: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(event.date),
                                    style: const TextStyle(
                                      color: Colors.purple,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Edit Event",
                                    style: TextStyle(color: Colors.purple),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is EventError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No Events Found"));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEventPage()),
            ),
        label: const Text("New Event"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}
