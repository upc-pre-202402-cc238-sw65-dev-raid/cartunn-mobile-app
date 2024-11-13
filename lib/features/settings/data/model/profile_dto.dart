import 'package:cartunn/features/settings/domain/entities/profile.dart';

class ProfileDTO {
  final int id;
  final String name;
  final String lastName;
  final String email;

  const ProfileDTO({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
  });

  factory ProfileDTO.fromJson(Map<String, dynamic> json) {
    return ProfileDTO(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'email': email,
    };
  }

  Profile toDomain() {
    return Profile(
      id: id,
      name: name,
      lastName: lastName,
      email: email,
    );
  }
}
