class UserEvent {
  final int id;
  final String name;
  final String description;
  final DateTime date;
  final String location;
  final int? weatherTemp;
  final String? weatherCondition;

  UserEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.location,
    this.weatherTemp,
    this.weatherCondition,
  });
}
