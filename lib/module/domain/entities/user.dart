class UserEntity {
  final String uid;
  final String email;
  final String? name;
  final String role;
  final bool isActive;

  UserEntity({
    required this.uid,
    required this.email,
    this.name,
    this.role = 'user',
    this.isActive = true,
  });
}
