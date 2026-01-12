
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.uid, // <--- Tambahkan ini
    required super.name,
    required super.email,
    required super.stylePreference,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Konversi aman ID (String/Int ke Int)
      id: json['user_id'] is String 
          ? int.tryParse(json['user_id']) ?? 0 
          : (json['user_id'] as int? ?? 0),
      
      // Ambil UID dari respon MySQL (biasanya kolomnya 'firebase_uid')
      uid: json['firebase_uid'] ?? '', 
      
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      stylePreference: json['style_preference'] ?? 'casual',
      avatarUrl: json['avatar_base64'] ?? json['avatar_url'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'firebase_uid': uid, // <--- Jangan lupa kirim balik saat simpan
      'name': name,
      'email': email,
      'style_preference': stylePreference,
      'avatar_url': avatarUrl,
    };
  }
}