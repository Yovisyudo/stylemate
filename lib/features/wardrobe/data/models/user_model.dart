import 'package:stylemate/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.stylePreference,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Kita paksa konversi ke int untuk berjaga-jaga jika server mengirim String
      id:
          json['user_id'] is String
              ? int.parse(json['user_id'])
              : json['user_id'] as int,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      stylePreference: json['style_preference'] ?? 'casual',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
      'style_preference': stylePreference,
    };
  }
}
