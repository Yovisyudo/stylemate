class User {
  final int id;
  final String name;
  final String email;
  final String uid;
  final String stylePreference;
  final String? avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.uid,
    required this.stylePreference,
    this.avatarUrl,
  });
  @override
  List<Object?> get props => [id, uid, name, email, stylePreference, avatarUrl];
}
