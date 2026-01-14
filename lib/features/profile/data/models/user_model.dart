class UserModel {
  final int id; // Pastikan INT jika di DB adalah int
  final String name;
  final String email;
  final String? stylePreference;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.stylePreference,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Pakai .toString() atau int.parse() jika ragu dengan tipe datanya dari API
      id:
          json['user_id'] is int
              ? json['user_id']
              : int.parse(json['user_id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      stylePreference: json['style_preference'],
      avatarUrl: json['avatar_url'],
    );
  }
}
