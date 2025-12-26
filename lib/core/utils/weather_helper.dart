import 'package:flutter/material.dart';

class WeatherHelper {
  // Fungsi untuk mendapatkan Icon berdasarkan kondisi dari backend
  static IconData getWeatherIcon(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'clouds':
        return Icons.wb_cloudy_outlined;
      case 'rain':
        return Icons.umbrella_outlined;
      case 'clear':
      case 'sunny':
        return Icons.wb_sunny_outlined;
      case 'thunderstorm':
        return Icons.thunderstorm_outlined;
      case 'snow':
        return Icons.ac_unit_outlined;
      default:
        return Icons.help_outline;
    }
  }

  // Fungsi untuk mendapatkan warna tema berdasarkan kondisi
  static Color getWeatherColor(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return Colors.orangeAccent;
      case 'rain':
      case 'clouds':
        return Colors.blueAccent;
      default:
        return Colors.purpleAccent;
    }
  }
}
