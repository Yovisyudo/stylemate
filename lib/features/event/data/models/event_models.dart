import 'package:stylemate/features/event/domain/entities/event.dart';

class EventModel extends UserEvent {
  EventModel({
    required super.id,
    required super.name,
    required super.description,
    required super.date,
    required super.location,
    super.weatherTemp,
    super.weatherCondition,
  });

  // Mapping dari JSON (Backend CI4) ke Model (Flutter)
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      // Mengambil 'event_id' dari DB dan memastikannya menjadi int
      id: json['event_id'] != null ? int.parse(json['event_id'].toString()) : 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      // Konversi String tanggal 'YYYY-MM-DD' menjadi DateTime
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      location: json['location'] ?? '',
      // Konversi suhu ke int (asumsi entitas Anda menggunakan int?)
      weatherTemp:
          json['weather_temp'] != null
              ? int.tryParse(json['weather_temp'].toString())
              : null,
      weatherCondition: json['weather_condition'],
    );
  }

  // Mapping dari Model ke JSON untuk dikirim ke Backend
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'date':
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}", // Format YYYY-MM-DD
      'location': location,
    };
  }
}
